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
    
    private let pushType: PushNotificationRedirectModel?
    
    // MARK: - Life Cycle
    
    init(pushType: PushNotificationRedirectModel? = nil) {
        self.pushType = pushType
        
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {        
        view = rootView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if ((UserDefaults.standard.string(forKey: "isLoggedIn")?.isEmpty) != nil) && KeychainManager.shared.loadAccessToken() != nil {
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
        NetworkService.shared.adventureService.getAdventureInfo(category: "NONE") { [weak self] response in
            guard let self else { return }
            switch response {
            case .success(let data):
                let characterName = data?.data.characterName ?? ""
                                                
                if characterName == "" {
                    self.presentViewController(viewController: LoginViewController())
                } else {
                    MyInfoManager.shared.updateCharacterListInfo()
                    self.presentViewController(viewController: OffroadTabBarController(pushType: pushType))
                }
            default:
                break
            }
        }
    }
    
}
