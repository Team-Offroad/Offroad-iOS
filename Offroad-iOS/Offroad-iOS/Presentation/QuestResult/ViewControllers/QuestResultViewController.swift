//
//  QuestResultViewController.swift
//  Offroad-iOS
//
//  Created by 김민성 on 2024/07/18.
//

import UIKit

import SnapKit
import Then

class QuestResultViewController: UIViewController {
    //MARK: - Properties
    
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let rootView = QuestResultView()
    var superViewControlller: UIViewController? = nil
    
    override func loadView() {
        view = rootView
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
}


extension QuestResultViewController {
    
    //MARK: - @objc Func
    
    
    
    //MARK: - Private Func
    
    
    
    //MARK: - Func
    
    
}
