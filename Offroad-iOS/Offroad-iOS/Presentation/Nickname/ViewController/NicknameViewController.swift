//
//  NicknameViewController.swift
//  Offroad-iOS
//
//  Created by  정지원 on 7/9/24.
//

import UIKit

import SnapKit
import Then

class NicknameViewController: UIViewController {
    private let nicknameView = NicknameView()
    
    override func loadView() {
        view = nicknameView
    }
    
    //MARK: - Life Cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.main(.main1)
        
        nicknameView.textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
    }

}

extension NicknameViewController {
    
    //MARK: - @objc
    
    @objc private func textFieldDidChange() {
        let isTextFieldEmpty = nicknameView.textField.text?.isEmpty ?? true
        if nicknameView.textField.isEnabled == true {
            nicknameView.textField.layer.borderColor = UIColor.sub(.sub).cgColor
        }
        nicknameView.checkButton.isEnabled = !isTextFieldEmpty
        nicknameView.checkButton.setTitleColor(isTextFieldEmpty ? UIColor.grayscale(.gray100) : UIColor.primary(.white), for: .normal)
        nicknameView.checkButton.backgroundColor = isTextFieldEmpty ? UIColor.main(.main3) : UIColor.primary(.black)
    }
}

