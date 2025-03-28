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
        
        KakaoAuthManager.shared.kakaoLogin()
        
        KakaoAuthManager.shared.loginSuccess = { token in
            let userAccessToken = token ?? ""
            
            self.postTokenForSocialLogin(request: SocialLoginRequestDTO(socialPlatform: "KAKAO", name: nil, code: userAccessToken))
        }
        
        KakaoAuthManager.shared.loginFailure = { error in
            print("login failed - \(error.localizedDescription)")
        }
    }
    
    private func appleLoginButtonTapped() {
        print("appleLoginButtonTapped")
        
        AppleAuthManager.shared.appleLogin()
        
        AppleAuthManager.shared.loginSuccess = { user, identifyToken in
            print("login success!")
            
            var userName = user.name ?? ""
            var userEmail = user.email ?? ""
            let userIdentifyToken = identifyToken ?? ""
                        
            if userName != "" {
                if let userDefaultName = KeychainManager.shared.loadUserName() {
                    userName = userDefaultName
                } else {
                    KeychainManager.shared.saveUserName(name: userName)
                }
            } else {
                userName = KeychainManager.shared.loadUserName() ?? ""
            }
            
            if userEmail != "" {
                if let userDefaultEmail = KeychainManager.shared.loadUserEmail() {
                    userEmail = userDefaultEmail
                } else {
                    KeychainManager.shared.saveUserEmail(email: userEmail)
                }
            } else {
                userEmail = KeychainManager.shared.loadUserEmail() ?? ""
            }
            
            self.postTokenForSocialLogin(request: SocialLoginRequestDTO(socialPlatform: "APPLE", name: userName, code: userIdentifyToken))
        }
        
        AppleAuthManager.shared.loginFailure = { error in
            print("login failed - \(error.localizedDescription)")
        }
    }
    
    private func postTokenForSocialLogin(request: SocialLoginRequestDTO) {
        NetworkService.shared.authService.postSocialLogin(body: request) { response in
            switch response {
            case .success(let data):
                let accessToken = data?.data.tokens.accessToken ?? ""
                let refreshToken = data?.data.tokens.refreshToken ?? ""
                
                KeychainManager.shared.saveAccessToken(token: accessToken)
                KeychainManager.shared.saveRefreshToken(token: refreshToken)
                
                UserDefaults.standard.set("\(request.socialPlatform)", forKey: "isLoggedIn")

                self.checkUserChoosingInfo()
            default:
                break
            }
        }
    }
    
    private func checkUserChoosingInfo() {
        NetworkService.shared.adventureService.getAdventureInfo(category: "NONE") { response in
            switch response {
            case .success(let data):
                let characterName = data?.data.characterName ?? ""
                                                
                if characterName == "" {
                    let termsConsentViewController = TermsConsentViewController()
                    termsConsentViewController.modalPresentationStyle = .fullScreen
                    termsConsentViewController.modalTransitionStyle = .crossDissolve

                    self.present(termsConsentViewController, animated: true)
                } else {
                    let offroadTabBarViewController = OffroadTabBarController()
                    
                    offroadTabBarViewController.modalPresentationStyle = .fullScreen
                    offroadTabBarViewController.modalTransitionStyle = .crossDissolve
                    
                    self.present(offroadTabBarViewController, animated: true)
                }
            default:
                break
            }
        }
    }
}
