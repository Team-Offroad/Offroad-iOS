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
    var superViewControlller: UIViewController? = nil
    
//    let superView
    
    override func loadView() {
        view = rootView
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButtonsAction()
    }
    
}


extension PlaceInfoPopupViewController {
    
    //MARK: - @objc Func
    
    @objc private func closePopupView() {
        print(#function)
        dismiss(animated: false)
    }
    
    @objc private func explore() {
        print(#function)
        
        guard let navigationController = superViewControlller as? UINavigationController else {
            print("not navicon")
            return
        }
        navigationController.pushViewController(QuestQRViewController(), animated: true)
        self.dismiss(animated: false)
    }
    
    //MARK: - Private Func
    
    private func setupButtonsAction() {
        rootView.closeButton.addTarget(self, action: #selector(closePopupView), for: .touchUpInside)
        rootView.exploreButton.addTarget(self, action: #selector(explore), for: .touchUpInside)
    }
    
    //MARK: - Func
    
    func configurePopupView(with placeInfo: RegisteredPlaceInfo) {
        rootView.configurePopupView(with: placeInfo)
    }
    
}
