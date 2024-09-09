//
//  CouponCodeInputPopupViewController.swift
//  Offroad-iOS
//
//  Created by 김민성 on 9/9/24.
//

import UIKit

class CouponCodeInputPopupViewController: UIViewController {
    
    //MARK: - Properties
    
    //MARK: - UI Properties
    
    let rootView = CouponCodeInputPopupView()
    
    //MARK: - Life Cycle
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
}
