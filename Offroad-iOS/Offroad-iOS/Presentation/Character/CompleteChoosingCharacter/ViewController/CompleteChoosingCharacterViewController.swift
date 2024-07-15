//
//  CompleteChoosingCharacterViewController.swift
//  Offroad-iOS
//
//  Created by  정지원 on 7/15/24.
//

import UIKit

import SnapKit
import Then

final class CompleteChoosingCharacterViewController: UIViewController {
    
    //MARK: - Properties
    
    private let completeChoosingCharacterView = CompleteChoosingCharacterView()
    
    //MARK: - Life Cycle
    
    override func loadView() {
        view = completeChoosingCharacterView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

