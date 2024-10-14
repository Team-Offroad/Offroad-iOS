//
//  ORBOverlayViewController.swift
//  Offroad-iOS
//
//  Created by 김민성 on 10/7/24.
//

import UIKit

class ORBOverlayViewController: UIViewController {
    
    //MARK: - Properties
    
    private let transitionDelegate = ZeroDurationTransitionDelegate()
    
    //MARK: - Life Cycle
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
        
        setupPresentationStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    

}

extension ORBOverlayViewController {
    
    //MARK: - Private Func
    
    private func setupPresentationStyle() {
        self.transitioningDelegate = transitionDelegate
        self.modalPresentationStyle = .custom
    }
    
}
