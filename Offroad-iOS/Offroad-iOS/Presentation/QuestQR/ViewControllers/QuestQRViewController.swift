//
//  QuestQRViewController.swift
//  Offroad-iOS
//
//  Created by 김민성 on 2024/07/11.
//

import UIKit

import SnapKit
import Then

class QuestQRViewController: UIViewController {
    
    //MARK: - Properties
    
    let questQRView = QuestQRView()
    
    //MARK: - Life Cycle
    
    override func loadView() {
        view = questQRView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let questMapNavigationController = navigationController as! QuestMapNavigationController
        questMapNavigationController.setCustomAppearance(state: .questQR)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let questMapNavigationController = navigationController as! QuestMapNavigationController
        questMapNavigationController.setCustomAppearance(state: .questMap)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationController()
        setupNavigationControllerGesture()
    }
    
}

extension QuestQRViewController {
    
    //MARK: - Private Func
    
    private func setNavigationController() {
        self.navigationItem.setHidesBackButton(true, animated: false)        
    }
    
    
    func setupNavigationControllerGesture() {
        navigationController?.interactivePopGestureRecognizer?.delegate = self
    }
    
}

//MARK: - UIGestureRecognizerDelegate

extension QuestQRViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        print(#function)
        
        // Navigation stack에서 root view controller가 아닌 경우에만 pop 제스처를 허용
        return navigationController!.viewControllers.count > 1
    }
    
}
