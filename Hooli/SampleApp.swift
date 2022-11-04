import SwiftUI
import UnumIDWebWallet
import HyperKYC
import AuthenticationServices

let enviroment: Enviroment = .sandbox

enum StateValue {
    case signup
    case initial
    case loading
    case success
}

@main
struct SampleApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    @State var state: StateValue = .signup
    @State var useExternalBrowser: Bool = true
    @State var isWebWalletPresented: Bool = false
    @State var error: Error?
    @State var email: String?
    @State var parameters: Parameters = Parameters(
        issuer: Constants.issuerDid(for: enviroment),
        callback: Constants.callbackUrl,
        presentationRequestId: Constants.presentationRequest(for: enviroment),
        enviroment: enviroment
    )
    
    var completion: ((_ result: HyperKycResult) -> Void)?
    
    var body: some Scene {
        WindowGroup {
            content()
            .launchWebWalletWithSharedSafariSession(isPresented: $isWebWalletPresented, parameters: parameters, completion: { result in
                switch result {
                case .success(let presentationRequestState):
                    switch presentationRequestState {
                    case .needsVerification(_):
                        showHyperKyc()
                    case .ok:
                        self.state = .success
                    @unknown default:
                        self.state = .initial
                    }
                case .failure(let error):
                    debugPrint(error.localizedDescription)
                    self.error = error
                }
            })
            .onContinueUserActivity(NSUserActivityTypeBrowsingWeb, perform: launchUrl(userActivity:))
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
            .emittingError($error) { recoveryOption in
                switch recoveryOption {
                case .retry:
                    debugPrint("Retry")
                default:
                    return
                }
            }
            .ignoresSafeArea()
            .preferredColorScheme(.light)
        }
    }
    
    func launchUrl(userActivity: NSUserActivity) {
        debugPrint("launchUrl continue user activity: \(userActivity.activityType)")
    }
    
    private func content() -> some View {
        ZStack {
            Color.white
            switch state {
            case .signup:
                SignUpView { email in
                    self.email = email
                    self.parameters = Parameters(
                        userEmail: email,
                        issuer: Constants.issuerDid(for: enviroment),
                        callback: Constants.callbackUrl,
                        presentationRequestId: Constants.presentationRequest(for: enviroment),
                        enviroment: enviroment
                    )
                    self.state = .initial
                }
            case .initial:
                VerifyView(
                    buttonAction: launchWebWallet,
                    sendLogsAction: sendLogs
                )
            case .loading:
                LoadingView(
                    color: .blue,
                    size: CGSize(width: 100, height: 100)
                )
            case .success:
                VerifiedView()
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
                self.state = .success
            @unknown default:
                self.state = .signup
            }
        case .failure(let error):
            debugPrint(error.localizedDescription)
            self.error = error
        }
    }
    
    private func openInSafari(url: URL) {
        UIApplication.shared.open(url, options: [:])
    }
    
    private func launchWebWallet() {
        if useExternalBrowser {
            openInSafari(url: parameters.webWalletURL)
        } else {
            isWebWalletPresented = true
        }
    }
    
    private func sendLogs() {
        do {
            try UnumID.shared.sendLogsViaEmail(presentingViewController: UIApplication.shared.rootViewController!)
        } catch {
            debugPrint(error.localizedDescription)
        }
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
                self.state = .initial
            default:
                self.parameters = Parameters(
                    userCode: Constants.userCode,
                    userEmail: email,
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

extension HyperKycResult: ObservableObject {}

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
