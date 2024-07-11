//
//  TitlePopupViewController.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 7/11/24.
//

import UIKit

final class TitlePopupViewController: UIViewController {
    
    //MARK: - Properties
    
    private let rootView = TitlePopupView(frame: CGRect(x: 0, y: 0, width: 345, height: 430))
    
    // MARK: - Life Cycle
    
    override func loadView() {
        view = UIView(frame: UIScreen.main.bounds)
        view.addSubview(rootView)
        rootView.center = view.center
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTarget()
    }
}

extension TitlePopupViewController {
    
    // MARK: - Private Func
    
    private func setupTarget() {
        rootView.setupButton(action: buttonTapped)
    }
    
    private func buttonTapped() {
        
    }
}
