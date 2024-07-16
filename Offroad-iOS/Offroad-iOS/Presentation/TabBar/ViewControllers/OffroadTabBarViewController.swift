//
//  OffroadTabBarViewController.swift
//  Offroad-iOS
//
//  Created by 김민성 on 2024/07/12.
//

import UIKit

import SnapKit
import Then

class OffroadTabBarViewController: UIViewController {
    
    //MARK: Life Cycle
    
    override func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        guard let offroadTabBarController = self.tabBarController as? OffroadTabBarController else { return }
        additionalSafeAreaInsets.bottom = 96 - offroadTabBarController.originalTabBarHeight
    }
    
}
