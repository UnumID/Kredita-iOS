import SwiftUI
import UnumIDWebWallet
import HyperKYC
import AuthenticationServices
import LogRocket
import Firebase
import FirebaseRemoteConfig

let enviroment: Enviroment = .sandbox

enum StateValue {
    case signup
    case loading
    case verified
    case success
}

@main
struct KreditaApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    
    @State var state: StateValue = .signup
    @State var isWebWalletPresented: Bool = false
    @State var error: Error?
    @State var parameters: Parameters = Parameters(
        issuer: Constants.issuerDid(for: enviroment),
        callback: Constants.callbackUrl,
        presentationRequestId: Constants.presentationRequest(for: enviroment),
        enviroment: enviroment
    )
    @State var useExternalBrowser = true
    private var remoteConfig: RemoteConfig!
    
    var completion: ((_ result: HyperKycResult) -> Void)?
    
    init() {
        FirebaseApp.configure()
        remoteConfig = RemoteConfig.remoteConfig()
        let settings = RemoteConfigSettings()
        settings.minimumFetchInterval = 0
        remoteConfig.configSettings = settings
    }
    
    var body: some Scene {
        WindowGroup {
            content()
                .launchWebWalletWithSharedSafariSession(
                    isPresented: $isWebWalletPresented,
                    parameters: parameters, barTintColor: Color(hex: "FFAD00"),
                    controlTintColor: Color(hex: "FFAD00"),
                    completion: { handleStateUpdate(with: $0) }
                )
                .emittingError($error) { recoveryOption in
                    switch recoveryOption {
                    case .retry:
                        debugPrint("Retry")
                    default:
                        return
                    }
                }
                .onOpenURL { url in
                    let queryParams = url.queryItemsDictionary
                    if let error = queryParams["error"] {
                        handleStateUpdate(with: .failure(UnumError.text(error)))
                    } else if let did = queryParams["subjectDid"] {
                        let subject = Subject(did: did)
                        handleStateUpdate(with: .success(.needsVerification(subject)))
                    } else {
                        handleStateUpdate(with: .success(.ok))
                    }
                }
                .ignoresSafeArea(.all)
                .preferredColorScheme(.light)
                .onAppear {
                    remoteConfig.fetch { (status, error) -> Void in
                        if status == .success {
                            debugPrint("Config fetched!")
                            remoteConfig.activate { changed, error in
                                useExternalBrowser = remoteConfig.configValue(forKey: "useExternalBrowser").boolValue
                            }
                        } else {
                            debugPrint("Config not fetched")
                            debugPrint("Error: \(error?.localizedDescription ?? "No error available.")")
                        }
                    }
                }
        }
    }
    
    private func content() -> some View {
        ZStack {
            Color.white
            switch state {
            case .signup:
                SignUpView(action: launchWebWallet)
            case .loading:
                EmptyView()
            case .verified:
                VerifiedView(action: showSuccessView)
            case .success:
                SuccessView(color: UIColor(named: "color_green")!)
                    .frame(width: 100, height: 100, alignment: .center)
            }
        }
    }
    
    private func handleStateUpdate(
        with result: Result<PresentationRequestState, Error>
    ) {
        switch result {
        case .success(let presentationRequestState):
            switch presentationRequestState {
            case .needsVerification(_):
                showHyperKyc()
                return
            case .ok:
                self.state = .verified
            @unknown default:
                self.state = .signup
            }
        case .failure(let error):
            debugPrint(error.localizedDescription)
            self.error = error
        }
    }
    
    private func showSuccessView() {
        self.state = .success
    }
    
    private func launchWebWallet() {
        if useExternalBrowser {
            openInSafari(url: parameters.webWalletURL)
        } else {
            isWebWalletPresented = true
        }
    }
    
    private func openInSafari(url: URL) {
        UIApplication.shared.open(url, options: [:])
    }
    
    private func showHyperKyc() {
        guard let vc = UIApplication.shared.rootViewController else { return }
        HyperKyc.launch(
            vc,
            hyperKycConfig: HyperKycConfig(
                appId: Constants.appId,
                appKey: Constants.appKey,
                workflowId: Constants.workflowId,
                transactionId: Constants.userCode
            ), { result in
                
                guard let status = result.status else { return }
                
                switch status {
                case "user_cancelled":
                    self.state = .signup
                default:
                    self.parameters = Parameters(
                        userCode: Constants.userCode,
                        issuer: Constants.issuerDid(for: enviroment),
                        callback: Constants.callbackUrl,
                        presentationRequestId: Constants.presentationRequest(for: enviroment),
                        enviroment: enviroment
                    )
                    self.state = .loading
                    
                    if useExternalBrowser {
                        self.openInSafari(url: parameters.webWalletURL)
                    } else {
                        self.isWebWalletPresented = true
                    }
                }
            })
    }
}

fileprivate extension URL {
    var queryItemsDictionary: [String: String] {
        var queryItemsDictionary = [String: String]()
        guard let components = URLComponents(url: self, resolvingAgainstBaseURL: false), let queryItems = components.queryItems else {
            return queryItemsDictionary
        }
        queryItems.forEach {
            queryItemsDictionary[$0.name] = $0.value
        }
        
        return queryItemsDictionary
    }
}
