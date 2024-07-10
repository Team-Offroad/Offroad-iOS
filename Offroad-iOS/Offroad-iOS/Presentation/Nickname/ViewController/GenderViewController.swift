//
//  GenderViewController.swift
//  Offroad-iOS
//
//  Created by  정지원 on 7/10/24.
//

import UIKit

import SnapKit
import Then

final class GenderViewController: UIViewController {
    
    //MARK: - Properties
    
    private let genderView = GenderView()
    
    //MARK: - Life Cycle
    
    override func loadView() {
        view = genderView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupAddTarget()
    }
    
    //MARK: - Private Method
    
    private func setupAddTarget() {
        genderView.maleButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        genderView.femaleButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        genderView.etcButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
    }
}

extension GenderViewController {
    
    //MARK: - @objc Method
    @objc func buttonTapped(_ sender: UIButton) {
        
        [genderView.maleButton, genderView.femaleButton, genderView.etcButton].forEach { button in
            button.isSelected = false
            button.layer.borderColor = UIColor.grayscale(.gray100).cgColor
        }

        sender.isSelected = true
        sender.layer.borderColor = UIColor.sub(.sub).cgColor
    }
}



