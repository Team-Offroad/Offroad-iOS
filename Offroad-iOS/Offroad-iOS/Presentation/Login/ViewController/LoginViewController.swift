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
            
            var userName = user.name ?? ""
            var userEmail = user.email ?? ""
            let userIdentifyToken = identifyToken ?? ""
            
            if let userDefaultName = UserDefaults.standard.string(forKey: "UserName") {
                userName = userDefaultName
            } else {
                UserDefaults.standard.set(userName, forKey: "UserName")
            }
            
            if let userDefaultEmail = UserDefaults.standard.string(forKey: "UserEmail") {
                userEmail = userDefaultEmail
            } else {
                UserDefaults.standard.set(userEmail, forKey: "UserEmail")
            }
            
            self.postTokenForAppleLogin(request: SocialLoginRequestDTO(socialPlatform: "APPLE", name: userName, code: userIdentifyToken))
        }
        
        AppleAuthManager.shared.loginFailure = { error in
            print("login failed - \(error.localizedDescription)")
        }
    }
    
    private func postTokenForAppleLogin(request: SocialLoginRequestDTO) {
        NetworkService.shared.authService.postSocialLogin(body: request) { [weak self] response in
            switch response {
            case .success(let data):
                let accessToken = data?.data.accessToken ?? ""
                let refreshToken = data?.data.refreshToken ?? ""
                
                UserDefaults.standard.set(accessToken, forKey: "AccessToken")
                UserDefaults.standard.set(refreshToken, forKey: "RefreshToken")
                
                self?.presentToNextVC()
            default:
                break
            }
        }
    }
    
    private func presentToNextVC() {
        // nickNameVC 가 보여지게 하고 싶다.
        // 그런데 push도 하게 하고 싶다.
        let nicknameViewController = NicknameViewController()
        
        present(UINavigationController(rootViewController: NicknameViewController()), animated: true)
    }
}
