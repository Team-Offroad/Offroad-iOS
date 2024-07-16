//
//  OffroadTabBarController.swift
//  Offroad-iOS
//
//  Created by 김민성 on 2024/07/12.
//

import UIKit

class OffroadTabBarController: UITabBarController {
    
    // MARK: - Properties
    
    var originalTabBarHeight: CGFloat = 0
    private var hideTabBarAnimator = UIViewPropertyAnimator(duration: 0.4, dampingRatio: 1)
    private var showTabBarAnimator = UIViewPropertyAnimator(duration: 0.4, dampingRatio: 1)
    
    // MARK: - UI Properties
    
    // MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupStyle()
        setOffroadViewControllers()
        setTabBarButtons()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        originalTabBarHeight = tabBar.frame.height
        
        let tabBarHeightFromBottomEdge: CGFloat = 96
        var newFrame = tabBar.frame
        newFrame.size.height = tabBarHeightFromBottomEdge
        newFrame.origin.y = view.frame.size.height - tabBarHeightFromBottomEdge
        tabBar.frame = newFrame
    }
}

extension OffroadTabBarController {
    
    // MARK: - Layout
    
    private func setupStyle() {
        tabBar.clipsToBounds = false
        tabBar.backgroundColor = .sub(.sub4)
        
        tabBar.tintColor = .main(.main1)
        tabBar.unselectedItemTintColor = .main(.main175)
    }
    
    private func setOffroadViewControllers() {
        let viewControllersArray: [UIViewController] = [
            HomeViewController(),
            QuestMapNavigationController(rootViewController: QuestMapViewController()),
            LoginViewController()
        ]
        
        setViewControllers(viewControllersArray, animated: false)
        selectedIndex = 1
    }
    
    private func setTabBarButtons() {
        tabBar.items?[0].image = UIImage.icnHome
        tabBar.items?[0].title = "Home"
        tabBar.items?[1].image = UIImage.icnTabBarOffroadLogo
        tabBar.items?[1].title = "Quest"
        tabBar.items?[2].image = UIImage.icnPerson
        tabBar.items?[2].title = "My"
    }
        
    // MARK: - Func
    
    func hideTabBarAnimation(delayFactor: CGFloat = 0) {
        hideTabBarAnimator.addAnimations({ [weak self] in
            self?.showTabBarAnimator.stopAnimation(true)
            self?.tabBar.frame.origin.y = UIScreen.current.bounds.height + 20
        }, delayFactor: delayFactor)
        hideTabBarAnimator.startAnimation()
    }
    
    func showTabBarAnimation(delayFactor: CGFloat = 0) {
        showTabBarAnimator.addAnimations({ [weak self] in
            self?.hideTabBarAnimator.stopAnimation(true)
            self?.tabBar.frame.origin.y = UIScreen.current.bounds.height - 96
        }, delayFactor: delayFactor)
        showTabBarAnimator.startAnimation()
    }
}
