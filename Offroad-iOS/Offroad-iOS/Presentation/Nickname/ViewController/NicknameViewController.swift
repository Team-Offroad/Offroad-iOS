//
//  NicknameViewController.swift
//  Offroad-iOS
//
//  Created by  정지원 on 7/9/24.
//

import UIKit

import SnapKit
import Then

class NicknameViewController: UIViewController, UITextFieldDelegate {
    private let nicknameView = NicknameView()
    
    //MARK: - Life Cycle
    
    override func loadView() {
        view = nicknameView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.main(.main1)
        
        nicknameView.textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        nicknameView.textField.delegate = self
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
    // 화면 터치 시 키보드 내려가게 하는 코드
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    // return키 눌렀을 때 키보드 내려가게 하는 코드
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

