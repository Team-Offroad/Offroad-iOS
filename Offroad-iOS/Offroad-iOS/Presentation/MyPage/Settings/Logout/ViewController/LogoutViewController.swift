//
//  LogoutViewController.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 9/3/24.
//

import UIKit

final class LogoutViewController: UIViewController {
    
    //MARK: - Properties
    
    private let rootView = LogoutView()
    
    // MARK: - Life Cycle
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAddTarget()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        rootView.presentPopupView()
    }
}

extension LogoutViewController {
    
    // MARK: - Private Method
    
    private func setupAddTarget() {
        rootView.yesButton.addTarget(self, action: #selector(yesButtonTapped), for: .touchUpInside)
        rootView.noButton.addTarget(self, action: #selector(noButtonTapped), for: .touchUpInside)
    }
    
    //MARK: - @Objc Func
    
    @objc private func yesButtonTapped() {
        KeychainManager.shared.deleteAccessToken()
        KeychainManager.shared.deleteRefreshToken()
        UserDefaults.standard.set(false, forKey: "isLoggedIn")
        
        let splashViewController = SplashViewController()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            UIWindow.current.rootViewController = splashViewController
        }
    }
    
    @objc private func noButtonTapped() {
        rootView.dismissPopupView {
            self.dismiss(animated: false)
        }
    }
}
