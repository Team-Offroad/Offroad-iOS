//
//  QuestMapViewController.swift
//  Offroad-iOS
//
//  Created by 김민성 on 2024/07/07.
//

import UIKit

import NMapsMap
import SnapKit
import Then

class QuestMapViewController: UIViewController {
    
    //MARK: - UI Properties
    
    let rootView = QuestMapView()
    
    //MARK: - Life Cycle
    
    override func loadView() {
        view = rootView
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let questMapNavigationController = navigationController as! QuestMapNavigationController
        questMapNavigationController.customNavigationBar.changeState(to: .questMap)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButtonsAction()
    }
    
}


extension QuestMapViewController {
    
    //MARK: - @objc
    
    @objc private func pushQuestListViewController() {
        print(#function)
        navigationController?.pushViewController(QuestQRViewController(), animated: true)
    }
    
    @objc private func pushPlaceListViewController() {
        print(#function)
        navigationController?.pushViewController(QuestQRViewController(), animated: true)
    }
    
    //MARK: - Private Func
    
    private func setupButtonsAction() {
        rootView.questListButton.addTarget(self, action: #selector(pushQuestListViewController), for: .touchUpInside)
        rootView.placeListButton.addTarget(self, action: #selector(pushPlaceListViewController), for: .touchUpInside)
    }
    
}
