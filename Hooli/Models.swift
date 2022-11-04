import Foundation

struct WebauthnRequestResponse: Codable {
    struct WebauthnCredential: Codable {
        let uuid: String
        let createdAt: Date
        let updatedAt: Date
        let id: String
        let publicKeyPEM: String
        let type: String
        let attestationObject: String
        let clientDataJSON: String
        let user: String
        let browserName: String
        let deviceOs: String
    }
    let webauthnCredentials: [WebauthnCredential]
    let challenge: String
    let userUuid: String
    let isEmailVerified: Bool
    struct AssertionOptions: Codable {
        struct Challenge: Codable {
            let type: String
            let data: [Int]
        }
        let challenge: Challenge
        let timeout: Int
        let rpId: String
        let userVerification: String
        struct AllowCredential: Codable {
            struct Id: Codable {
                let type: String
                let data: [Int]
            }
            let id: Id
            let type: String
        }
        let allowCredentials: [AllowCredential]
        let attestation: String
    }
    let assertionOptions: AssertionOptions
}

struct AuthRequest: Codable {
    let strategy: String
    struct Assertion: Codable {
        let id: String
        let rawId: String
        let type: String
        struct Response: Codable {
            let authenticatorData: String
            let clientDataJSON: String
            let signature: String
            let userHandle: String
        }
        let response: Response
    }
    let assertion: Assertion
}

struct AuthResponse: Codable {
    let accessToken: String
    struct Authentication: Codable {
        let strategy: String
        let accessToken: String
        struct Payload: Codable {
            let webauthnCredentialUuid: String
            let uuid: String
            let did: String
            let email: String
            let referralCode: String
            let iat: Date
            let exp: Date
            let aud: String
            let iss: String
            let sub: String
            let jti: String
        }
        let payload: Payload
    }
    let authentication: Authentication
    struct User: Codable {
        let uuid: String
        let createdAt: Date
        let updatedAt: Date
        let email: String
        struct WebauthnCredential: Codable {
            let uuid: String
            let createdAt: Date
            let updatedAt: Date
            let id: String
            let publicKeyPEM: String
            let type: String
            let attestationObject: String
            let clientDataJSON: String
            let user: String
            let browserName: String
            let deviceOs: String
        }
        let webauthnCredentials: [WebauthnCredential]
        let challenge: String
        let did: String
        let updateKey: String
        let encryptionKeyId: String
        let signingKeyId: String
        let isEmailVerified: Bool
        let encryptionKeyIds: [String]
        let signingKeyIds: [String]
        let referralCode: String
        let termsVersionAccepted: String
        struct EmailUser: Codable {
            let uuid: String
            let createdAt: Date
            let updatedAt: Date
            let isClassifying: Bool
            let connectedEmailProvider: String
        }
        let emailUser: EmailUser
    }
    let user: User
    let isValid: Bool
    struct WebauthnCredential: Codable {
        let uuid: String
        let createdAt: Date
        let updatedAt: Date
        let id: String
        let publicKeyPEM: String
        let type: String
        let attestationObject: String
        let clientDataJSON: String
        let user: String
        let browserName: String
        let deviceOs: String
    }
    let webauthnCredential: WebauthnCredential
}

struct AttestationRequest: Codable {
    let strategy: String
    struct Attestation: Codable {
        let id: String
        let rawId: String
        let type: String
        struct Response: Codable {
            let clientDataJSON: String
            let attestationObject: String
        }
        let response: Response
    }
    let attestation: Attestation
    let userUuid: String
    struct HolderOptions: Codable {
        let browserName: String
        let deviceOs: String
        let type: String
    }
    let holderOptions: HolderOptions
}
