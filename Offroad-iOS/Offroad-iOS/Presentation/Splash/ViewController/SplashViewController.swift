//
//  SplashViewController.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 7/8/24.
//

import UIKit

final class SplashViewController: UIViewController {
    
    //MARK: - Properties
    
    private let rootView = SplashView()
    
    // MARK: - Life Cycle
    
    override func loadView() {        
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.rootView.dismissOffroadLogiView()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            self.presentLoginViewController()
        }
    }
}

extension SplashViewController {
    
    //MARK: - Private Func
    
    private func presentLoginViewController() {
        let loginViewController = LoginViewController()
        loginViewController.modalTransitionStyle = .crossDissolve
        loginViewController.modalPresentationStyle = .fullScreen
        
        present(loginViewController, animated: true, completion: nil)
    }
}
