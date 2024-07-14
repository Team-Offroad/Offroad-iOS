//
//  LoginViewController.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 7/8/24.
//

import UIKit

import AuthenticationServices

final class LoginViewController: UIViewController {
    
    //MARK: - Properties
    
    private let rootView = LoginView()
    
    // MARK: - Life Cycle
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTarget()
    }
}

extension LoginViewController {
    
    // MARK: - Private Method
    
    private func setupTarget() {
        rootView.setupKakaoLoginButton(action: kakaoLoginButtonTapped)
        rootView.setupAppleLoginButton(action: appleLoginButtonTapped)
    }
    
    private func kakaoLoginButtonTapped() {
        print("kakaoLoginButtonTapped")
    }
    
    private func appleLoginButtonTapped() {
        print("appleLoginButtonTapped")
        
        appleLoginHandler()
    }
    
    private func appleLoginHandler() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let request = appleIDProvider.createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let authorizationController = ASAuthorizationController(authorizationRequests: [request])
        authorizationController.delegate = self
        authorizationController.presentationContextProvider = self
        authorizationController.performRequests()
    }
}

extension LoginViewController: ASAuthorizationControllerDelegate, ASAuthorizationControllerPresentationContextProviding{
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return self.view.window!
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
//              로그인 성공
                  switch authorization.credential {
                  case let appleIDCredential as ASAuthorizationAppleIDCredential:
                      // You can create an account in your system.
                      let userIdentifier = appleIDCredential.user
                      let fullName = appleIDCredential.fullName
                      let email = appleIDCredential.email
        
                      if  let authorizationCode = appleIDCredential.authorizationCode,
                          let identityToken = appleIDCredential.identityToken,
                          let authCodeString = String(data: authorizationCode, encoding: .utf8),
                          let identifyTokenString = String(data: identityToken, encoding: .utf8) {
                          print("authorizationCode: \(authorizationCode)")
                          print("---------")
                          print("identityToken: \(identityToken)")
                          print("---------")
                          print("authCodeString: \(authCodeString)")
                          print("---------")
                          print("identifyTokenString: \(identifyTokenString)")
                      }
                      print("---------")
                      print("---------")
                      print("---------")
                      print("useridentifier: \(userIdentifier)")
                      print("fullName: \((fullName?.givenName ?? "") + (fullName?.familyName ?? ""))")
                      print("email: \(email ?? "")")
        
                  case let passwordCredential as ASPasswordCredential:
                      // Sign in using an existing iCloud Keychain credential.
                      let username = passwordCredential.user
                      let password = passwordCredential.password
        
                      print("username: \(username)")
                      print("password: \(password)")
        default:
            break
        }
    }
    
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        // 로그인 실패(유저의 취소도 포함)
        print("login failed - \(error.localizedDescription)")
    }
}
