import Foundation
import UnumIDWebWallet

public struct Constants {
    public static let appId = ""
    public static let appKey = ""
    public static let workflowId = ""
    public static let scheme = "hooli"
    public static let callbackUrl = "https://link.sandbox-unumid.co/hooli"
    public static let userCode = UUID().uuidString.lowercased()
    
    public enum LogRocket {
        public static let appID = ""
    }
    
    public static func issuerDid(for enviroment: Enviroment) -> String {
        switch enviroment {
        case .dev:
            return ""
        case .sandbox:
            return ""
        case .production:
            fatalError()
        @unknown default:
            fatalError()
        }
    }
    
    public static func presentationRequest(for enviroment: Enviroment) -> String {
        switch enviroment {
        case .dev:
            return "797d37e6-381b-4c44-a2fa-34c1b715f989"
        case .sandbox:
            return "eb1738ff-fb57-4490-820f-7ae6c7f91e36"
        case .production:
            fatalError()
        @unknown default:
            fatalError()
        }
    }
}
