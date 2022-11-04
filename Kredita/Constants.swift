import Foundation
import UnumIDWebWallet

public struct Constants {
    public static let appId = ""
    public static let appKey = ""
    public static let workflowId = ""
    public static let scheme = "kredita"
    public static let callbackUrl = "https://link.sandbox-unumid.co/kredita"
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
            return ""
        case .sandbox:
            return ""
        case .production:
            fatalError()
        @unknown default:
            fatalError()
        }
    }
}
