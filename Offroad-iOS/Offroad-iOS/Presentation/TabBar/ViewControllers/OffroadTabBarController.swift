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
            MyPageViewController()
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
    
}