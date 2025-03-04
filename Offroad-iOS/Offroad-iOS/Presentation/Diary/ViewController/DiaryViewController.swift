//
//  DiaryViewController.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 3/4/25.
//

import UIKit

final class DiaryViewController: UIViewController {
    
    // MARK: - Properties
    
    private let rootView = DiaryView()
    
    // MARK: - Life Cycle
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTarget()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        guard let offroadTabBarController = self.tabBarController as? OffroadTabBarController else { return }
        offroadTabBarController.hideTabBarAnimation()
    }
}

extension DiaryViewController {
    
    // MARK: - Func
    
    func setupCustomBackButton(buttonTitle: String) {
        rootView.customBackButton.configureButtonTitle(titleString: buttonTitle)
    }
}

private extension DiaryViewController {
    
    // MARK: - Private Method
    
    func setupTarget() {
        rootView.customBackButton.addTarget(self, action: #selector(backButtonTapped), for: .touchUpInside)
    }
}
    
@objc private extension DiaryViewController {

    // MARK: - @objc Method
    
    func backButtonTapped() {
        self.navigationController?.popViewController(animated: true)
    }
}
