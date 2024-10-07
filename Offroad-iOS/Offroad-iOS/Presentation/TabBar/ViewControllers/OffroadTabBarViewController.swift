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
        // 92: 현재 오브 탭바의 높이
        additionalSafeAreaInsets.bottom = 92 - offroadTabBarController.originalTabBarHeight
    }
    
}
