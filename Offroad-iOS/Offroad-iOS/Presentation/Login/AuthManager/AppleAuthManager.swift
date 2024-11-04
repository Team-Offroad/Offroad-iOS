//
//  AppleAuthManager.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 7/15/24.
//

import AuthenticationServices

enum AppleLoginType {
    case initialLogin
    case getAuthorizationCode
}

final class AppleAuthManager: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    static let shared = AppleAuthManager()
    
    private override init() {}
    
    var loginType: AppleLoginType?
    
    var loginSuccess: ((UserModel, String?) -> Void)?
    var loginFailure: ((Error) -> Void)?
    var loadAuthorizationCode: ((String?) -> Void)?
    
    func appleLogin() {
        loginType = .initialLogin
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
    
    func getAuthorizationCode() {
        loginType = .getAuthorizationCode
        
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        request.requestedOperation = .operationLogout
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.performRequests()
    }
}

extension AppleAuthManager {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else { return }
        
        switch loginType {
        case .initialLogin:
            let user = UserModel(userIdentifier: appleIDCredential.user,
                                 name: (appleIDCredential.fullName?.familyName ?? "") + (appleIDCredential.fullName?.givenName ?? ""),
                                 email: appleIDCredential.email)
            
            let userIdentityToken = appleIDCredential.identityToken ?? Data()
            let userIdentifyTokenString = String(data: userIdentityToken, encoding: .utf8)
            
            loginSuccess?(user, userIdentifyTokenString)
        case .getAuthorizationCode:
            let authorizationCode = appleIDCredential.authorizationCode ?? Data()
            let authorizationCodeString = String(data: authorizationCode, encoding: .utf8)
            
            loadAuthorizationCode?(authorizationCodeString)
        default:
            break
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        loginFailure?(error)
    }
    
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { fatalError("No window is available") }
        return window
    }
}
