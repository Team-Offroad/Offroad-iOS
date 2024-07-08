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
        super.loadView()
        
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        navigationController?.isNavigationBarHidden = true
    }
}

extension SplashViewController {
    
    // MARK: - Private Method
    
}
