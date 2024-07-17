//
//  PlaceInfoPopupViewController.swift
//  Offroad-iOS
//
//  Created by 김민성 on 2024/07/17.
//

import UIKit

import SnapKit
import Then

class PlaceInfoPopupViewController: UIViewController {
    
    let rootView = PlaceInfoPopupView()
    
    override func loadView() {
        view = rootView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButtonsAction()
    }
    
    
    
}


extension PlaceInfoPopupViewController {
    
    //MARK: - Private Func
    
    private func setupButtonsAction() {
        
    }
    
}
