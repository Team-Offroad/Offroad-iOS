//
//  ORBRecommendationMainViewController.swift
//  ORB_Dev
//
//  Created by 김민성 on 4/20/25.
//

import UIKit

final class ORBRecommendationMainViewController: UIViewController {
    
    let rootView = ORBRecommendationMainView()
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let offroadTabBarController = self.tabBarController as? OffroadTabBarController else { return }
        offroadTabBarController.hideTabBarAnimation()
    }
    
}
