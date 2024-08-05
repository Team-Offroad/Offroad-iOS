//
//  NicknameViewController.swift
//  Offroad-iOS
//
//  Created by  정지원 on 7/9/24.
//

import UIKit

import Moya
import SnapKit
import Then

final class NicknameViewController: UIViewController {
    
    //MARK: - Properties
    
    private let nicknameView = NicknameView()
    
    private var whetherDuplicate: Bool = false
    
    //MARK: - Life Cycle
    
    override func loadView() {
        view = nicknameView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupTarget()
        setupDelegate()
        view.backgroundColor = UIColor.main(.main1)
        
        self.modalPresentationStyle = .fullScreen
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        nicknameView.nextButton.changeState(forState: .isDisabled)
    }
}

extension NicknameViewController {
    
    //MARK: - @objc Method
    
    @objc private func textFieldDidChange() {
        let isTextFieldEmpty = nicknameView.textField.text?.isEmpty ?? true
        
        nicknameView.checkButton.isEnabled = !isTextFieldEmpty
        nicknameView.checkButton.setTitleColor(isTextFieldEmpty ? UIColor.grayscale(.gray100) : UIColor.primary(.white), for: .normal)
        nicknameView.checkButton.backgroundColor = isTextFieldEmpty ? UIColor.main(.main3) : UIColor.primary(.black)
        nicknameView.checkButton.layer.borderWidth = isTextFieldEmpty ? 1 : 0
        
        if isTextFieldEmpty {
            nicknameView.textField.layer.borderColor = UIColor.grayscale(.gray100).cgColor
            nicknameView.nextButton.changeState(forState: .isDisabled)
        } else {
            nicknameView.textField.layer.borderColor = UIColor.sub(.sub).cgColor
        }
    }
    
    // 화면 터치 시 키보드 내려가게 하는 코드
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
        
    }
    
    @objc private func checkButtonTapped() {
        NetworkService.shared.nicknameService.checkNicknameDuplicate(inputNickname: nicknameView.textField.text ?? "") { response in
            switch response {
            case .success(let data):
                self.whetherDuplicate = data?.data.isDuplicate ?? Bool()
                if self.whetherDuplicate == true {
                    self.nicknameView.notionLabel.text = "중복된 닉네임이에요. 다른 멋진 이름이 있으신가요?"
                    self.nicknameView.notionLabel.textColor = UIColor.primary(.error)
                }
                else if self.whetherDuplicate == false && self.formError(self.nicknameView.textField.text ?? "") == false {
                    self.nicknameView.notionLabel.text = "한글 2~8자, 영어 2~16자 이내로 다시 말씀해주세요."
                    self.nicknameView.notionLabel.textColor = UIColor.primary(.error)
                }
                else {
                    self.nicknameView.textField.resignFirstResponder()
                    self.nicknameView.notionLabel.text = "좋은 닉네임이에요!"
                    self.nicknameView.notionLabel.textColor = UIColor.grayscale(.gray400)
                    self.nicknameView.nextButton.changeState(forState: .isEnabled)
                }
            default:
                break
            }
        }
    }
    
    @objc func buttonToBirthVC(sender: UIButton) {
        let nextVC = BirthViewController(nickname: self.nicknameView.textField.text ?? "")
        
        let button = UIButton().then { button in
            button.setImage(.backBarButton, for: .normal)
            button.addTarget(self, action: #selector(executePop), for: .touchUpInside)
            button.imageView?.contentMode = .scaleAspectFill
            button.snp.makeConstraints { make in
                make.width.equalTo(30)
                make.height.equalTo(44)
            }
        }
        
        let customBackBarButton = UIBarButtonItem(customView: button)
        customBackBarButton.tintColor = .black
        nextVC.navigationItem.leftBarButtonItem = customBackBarButton
        
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
    @objc private func executePop() {
        navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Private Func
    
    private func setupTarget() {
        nicknameView.checkButton.addTarget(self, action: #selector(checkButtonTapped), for: .touchUpInside)
        nicknameView.textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        nicknameView.nextButton.addTarget(self, action: #selector(buttonToBirthVC), for: .touchUpInside)
    }
    
    private func setupDelegate() {
        nicknameView.textField.delegate = self
    }
    
    func formError(_ input: String) -> Bool{
        let pattern = "^[A-Za-z가-힣ㄱ-ㅎ]{2,8}$"
        let regex = try? NSRegularExpression(pattern: pattern)
        if let _ = regex?.firstMatch(in: input, options: [], range: NSRange(location: 0, length: input.count)) {
            print("정규식 통과")
            return true
        }
        print("유효하지 않은 id 형식입니다.")
        return false
    }
    
}

//MARK: - UITextFieldDelegate

extension NicknameViewController: UITextFieldDelegate {
    
    // return키 눌렀을 때 키보드 내려가게 하는 코드
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        textField.layer.borderColor = UIColor.sub(.sub).cgColor
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 백스페이스 처리
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if isBackSpace == -92 {
                return true
            }
        }
        //텍스트필드 8글자로 제한
        guard textField.text!.count < 8 else { return false }
        return true
    }
    
}

