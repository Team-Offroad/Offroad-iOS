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
    var questMapNavigationController: QuestMapNavigationController!
    
    //MARK: - Life Cycle
    
    override func loadView() {
        view = questQRView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        let questMapNavigationController = navigationController as! QuestMapNavigationController
        //questMapNavigationController.customNavigationBar.isHidden = true
        //questMapNavigationController.navigationBar.isHidden = true
        
        questMapNavigationController.customNavigationBar.backgroundColor = .clear
        questMapNavigationController.customStatusBarBackgorund.backgroundColor = .clear
        questMapNavigationController.customNavigationBarShadowLine.backgroundColor = .clear
        questMapNavigationController.customNavigationBar.changeState(to: .questQR)
        questMapNavigationController.setupAppearanceToTransparent()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        //let questMapNavigationController = navigationController as! QuestMapNavigationController
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        let questMapNavigationController = navigationController as! QuestMapNavigationController
        //questMapNavigationController.customNavigationBar.isHidden = false
        //questMapNavigationController.navigationBar.isHidden = false
        questMapNavigationController.customNavigationBar.backgroundColor = .main(.main1)
        questMapNavigationController.customStatusBarBackgorund.backgroundColor = .main(.main1)
        questMapNavigationController.customNavigationBarShadowLine.backgroundColor = .blackOpacity(.black25)
        questMapNavigationController.customNavigationBar.changeState(to: .questMap)
        //questMapNavigationController.setupAppearanceToOpaque()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setNavigationController()
        questMapNavigationController = navigationController as! QuestMapNavigationController
        setupLayout()
        setupNavigationControllerGesture()
    }
    
    
}


extension QuestQRViewController {
    
    
    
    //MARK: - Private Func
    
    private func setupLayout() {
    }
    
    private func setNavigationController() {
        self.navigationItem.setHidesBackButton(true, animated: false)        
    }
    
    
    func setupNavigationControllerGesture() {
        // Interactive Pop Gesture 활성화
        navigationController?.interactivePopGestureRecognizer?.delegate = self
        //interactivePopGestureRecognizer?.delegate = nil
    }
    
    
    //MARK: - Func
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        print(#function)
    }
    
}


extension QuestQRViewController: UIGestureRecognizerDelegate {
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        print(#function)
        
        // Navigation stack에서 root view controller가 아닌 경우에만 pop 제스처를 허용
        return navigationController!.viewControllers.count > 1
    }
    
}
