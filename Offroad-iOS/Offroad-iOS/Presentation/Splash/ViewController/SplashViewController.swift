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
        super.viewDidAppear(animated)
        
        if UserDefaults.standard.bool(forKey: "isLoggedIn") {
            checkUserChoosingInfo()
        } else {
            presentViewController(viewController: LoginViewController())
        }
    }
}

extension SplashViewController {
    
    //MARK: - Private Func
    
    private func presentViewController(viewController: UIViewController) {
        viewController.modalPresentationStyle = .overFullScreen
        viewController.modalTransitionStyle = .crossDissolve
        
        let transition = CATransition()
        transition.duration = 0.6
        transition.type = .fade
        transition.subtype = .fromRight
        view.window?.layer.add(transition, forKey: kCATransition)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.rootView.dismissOffroadLogiView {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
                    self.present(viewController, animated: true, completion: nil)
                }
            }
        }
    }
    
    private func checkUserChoosingInfo() {
        NetworkService.shared.adventureService.getAdventureInfo(category: "NONE") { response in
            switch response {
            case .success(let data):
                let userNickname = data?.data.nickname ?? ""
                let characterName = data?.data.characterName ?? ""
                                                
                if userNickname == "" {
                    self.presentViewController(viewController: TermsConsentViewController())
                } else if characterName == "" {
                    self.presentViewController(viewController: ChoosingCharacterViewController())
                } else {
                    self.presentViewController(viewController: OffroadTabBarController())
                }
            default:
                break
            }
        }
    }
}
