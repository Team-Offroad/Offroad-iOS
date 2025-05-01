//
//  ORBRecommendationOrderViewController.swift
//  ORB_Dev
//
//  Created by 김민성 on 5/1/25.
//

import UIKit

import RxSwift
import RxCocoa

final class ORBRecommendationOrderViewController: UIViewController {
    
    // MARK: - Properties
    
    let rootView = ORBRecommendationOrderView()
    
    // MARK: - Life Cycle
    
    override func loadView() {
        view  = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        rootView.backButton.addTarget(self, action: #selector(pop), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        guard let tabBarController  = tabBarController as? OffroadTabBarController else { return }
        tabBarController.hideTabBarAnimation()
    }
    
    @objc private func pop() {
        self.navigationController?.popViewController(animated: true)
    }
    
}
