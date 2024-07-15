//
//  AppleAuthManager.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 7/15/24.
//

import AuthenticationServices

final class AppleAuthManager: NSObject, ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding {
    
    static let shared = AppleAuthManager()
    
    private override init() {}
    
    var loginSuccess: ((UserModel, String?) -> Void)?
    var loginFailure: ((Error) -> Void)?
    
    func appleLogin() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
}

extension AppleAuthManager {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {              
        guard let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential else { return }
        
        let user = UserModel(userIdentifier: appleIDCredential.user,
                             name: (appleIDCredential.fullName?.givenName ?? "") + (appleIDCredential.fullName?.familyName ?? ""),
                             email: appleIDCredential.email)
        
        let userIdentityToken = appleIDCredential.identityToken ?? Data()
        let userIdentifyTokenString = String(data: userIdentityToken, encoding: .utf8)
        
        loginSuccess?(user, userIdentifyTokenString)
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
