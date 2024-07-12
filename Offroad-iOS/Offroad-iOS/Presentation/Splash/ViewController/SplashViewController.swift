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
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.rootView.dismissOffroadLogiView {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    self.presentLoginViewController()
                }
            }
        }
    }
}

extension SplashViewController {
    
    //MARK: - Private Func
    
    private func presentLoginViewController() {
        let loginViewController = LoginViewController()
        loginViewController.modalPresentationStyle = .fullScreen
        
        let transition = CATransition()
        transition.duration = 0.6
        transition.type = .fade
        transition.subtype = .fromRight
        view.window?.layer.add(transition, forKey: kCATransition)
        
        present(loginViewController, animated: false, completion: nil)
    }
}
