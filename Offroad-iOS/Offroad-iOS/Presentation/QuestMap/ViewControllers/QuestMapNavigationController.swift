//
//  QuestMapNavigationController.swift
//  Offroad-iOS
//
//  Created by 김민성 on 2024/07/07.
//

import UIKit

class QuestMapNavigationController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLayout()
        setNavigationBarStyle()
    }
    
    private func setNavigationBarStyle() {
        
    }
    
    private func setLayout() {
        navigationBar.frame.size = CGSize(width: UIScreen.current.bounds.width, height: 76)
    }
    
}
