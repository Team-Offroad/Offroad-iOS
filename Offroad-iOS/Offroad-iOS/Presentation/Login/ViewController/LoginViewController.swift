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
        
        AppleAuthManager.shared.appleLogin()
        
        AppleAuthManager.shared.loginSuccess = { user, identifyToken in
            print("login success!")
            
            let userName = user.name ?? ""
            let userEmail = user.email ?? ""
            let userIdentifyToken = identifyToken ?? ""

            print("userName: \(userName)")
            print("userEmail: \(userEmail)")
            print("userIdentifyToken: \(userIdentifyToken)")
            
            self.postTokenForAppleLogin(request: SocialLoginRequestDTO(socialPlatform: "APPLE", name: "정지원", code: userIdentifyToken))
        }
        
        AppleAuthManager.shared.loginFailure = { error in
            print("login failed - \(error.localizedDescription)")
        }
    }
    
    private func postTokenForAppleLogin(request: SocialLoginRequestDTO) {
        NetworkService.shared.authService.postSocialLogin(body: request) { response in
            switch response {
            case .success(let data):
                let accessToken = data?.data.accessToken ?? ""
                
                UserDefaults.standard.set(accessToken, forKey: "AccessToken")
                
                let nicknameViewController = NicknameViewController()
                nicknameViewController.modalPresentationStyle = .fullScreen
                
                self.present(nicknameViewController, animated: false)
            default:
                break
            }
        }
    }
}
