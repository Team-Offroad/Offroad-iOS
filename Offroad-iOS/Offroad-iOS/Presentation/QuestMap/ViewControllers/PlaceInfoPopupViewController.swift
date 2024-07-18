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
    
    //MARK: - Properties
    
    let placeInformation: RegisteredPlaceInfo
    
    init(placeInfo: RegisteredPlaceInfo) {
        placeInformation = placeInfo
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
        
        //분기처리
        let placeCategory = placeInformation.placeCategory
        if 
            placeCategory == OffroadPlaceCategory.park.rawValue ||
            placeCategory == OffroadPlaceCategory.park.rawValue ||
            placeCategory == OffroadPlaceCategory.park.rawValue 
        {
            // 위치 대조 API
            
            // 결과 반환 후 present
            
        } else {
            navigationController.pushViewController(
                QuestQRViewController(placeInformation: placeInformation),
                animated: true
            )
            self.dismiss(animated: false)
        }
    }
    
    //MARK: - Private Func
    
    private func setupButtonsAction() {
        rootView.closeButton.addTarget(self, action: #selector(closePopupView), for: .touchUpInside)
        rootView.exploreButton.addTarget(self, action: #selector(explore), for: .touchUpInside)
    }
    
    //MARK: - Func
    
    func configurePopupView() {
        rootView.configurePopupView(with: placeInformation)
    }
    
}
