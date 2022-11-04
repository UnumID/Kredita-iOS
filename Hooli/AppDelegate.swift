import UIKit
import LogRocket
import Firebase

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        
        SDK.initialize(configuration: Configuration(appID: Constants.LogRocket.appID))
        SDK.identify(userID: Constants.userCode)
        FirebaseApp.configure()
        
        return true
    }
}

