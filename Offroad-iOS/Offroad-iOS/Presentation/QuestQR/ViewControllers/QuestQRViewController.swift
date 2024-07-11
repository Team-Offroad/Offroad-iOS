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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
}


extension QuestQRViewController {
    
    
    
}
