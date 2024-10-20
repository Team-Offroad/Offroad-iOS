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
    }
}

extension NicknameViewController {
    //MARK: - Private Func
    
    private func setupTarget() {
        nicknameView.checkButton.addTarget(self, action: #selector(checkButtonTapped), for: .touchUpInside)
        nicknameView.textField.addTarget(self, action: #selector(textFieldDidBegin), for: .editingDidBegin)
        nicknameView.textField.addTarget(self, action: #selector(textFieldDidChange), for: .editingChanged)
        nicknameView.textField.addTarget(self, action: #selector(textFieldDidEnd), for: .editingDidEnd)
        nicknameView.nextButton.addTarget(self, action: #selector(buttonToBirthVC), for: .touchUpInside)
    }
    
    private func setupDelegate() {
        nicknameView.textField.delegate = self
    }
    
    private func configureButtonStyle(_ button: UIButton, isEnabled: Bool) {
        button.isEnabled = isEnabled
        button.setTitleColor(.primary(.white), for: .normal)
        button.backgroundColor = isEnabled ? .primary(.black) : .blackOpacity(.black15)
        button.roundCorners(cornerRadius: 5)
        
    }
    
    private func configureTextFieldStyle(_ textField: UITextField, isEmpty: Bool) {
        let borderColor: UIColor = isEmpty ? .grayscale(.gray100) : .main(.main2)
        textField.layer.borderColor = borderColor.cgColor
    }
    
    private func formError(_ input: String) -> Bool{
        let pattern = "^[A-Za-z가-힣]{2,}$"
        let regex = try? NSRegularExpression(pattern: pattern)
        let eucKrLength = input.eucKrByteLength
        if let _ = regex?.firstMatch(in: input, options: [], range: NSRange(location: 0, length: input.count)),
           eucKrLength >= 4 {
            print("정규식 통과")
            return true
        }
        print("유효하지 않은 id 형식입니다.")
        return false
    }
}

extension NicknameViewController {
    
    //MARK: - @objc Method
    
    @objc private func textFieldDidBegin() {
        let isTextFieldEmpty = nicknameView.textField.text?.isEmpty ?? true
        if isTextFieldEmpty {
            nicknameView.textField.layer.borderColor = UIColor.main(.main2).cgColor
        }
    }
    
    @objc private func textFieldDidEnd() {
        let isTextFieldEmpty = nicknameView.textField.text?.isEmpty ?? true
        if isTextFieldEmpty {
            nicknameView.textField.layer.borderColor = UIColor.grayscale(.gray100).cgColor
        }
    }
    
    @objc private func textFieldDidChange() {
        let isTextFieldEmpty = nicknameView.textField.text?.isEmpty ?? true
        configureButtonStyle(nicknameView.checkButton, isEnabled: !isTextFieldEmpty)
        configureTextFieldStyle(nicknameView.textField, isEmpty: isTextFieldEmpty)
        nicknameView.nextButton.changeState(forState: .isDisabled)
        
        if !formError(self.nicknameView.textField.text ?? "") && !isTextFieldEmpty {
            nicknameView.notionLabel.text = "한글 2~8자, 영어 2~16자 이내로 다시 작성해주세요."
            nicknameView.notionLabel.textColor = UIColor.primary(.error)
            nicknameView.textField.layer.borderColor = UIColor.primary(.error).cgColor
            nicknameView.nextButton.changeState(forState: .isDisabled)
        }
        else if isTextFieldEmpty {
            nicknameView.notionLabel.text = "*한글 2~8자, 영어 2~16자 이내로 작성해주세요."
            nicknameView.notionLabel.textColor = UIColor.grayscale(.gray400)
            nicknameView.notionLabel.font = UIFont.offroad(style: .iosHint)
            nicknameView.textField.layer.borderColor = UIColor.main(.main2).cgColor
        }
        else {
            nicknameView.notionLabel.text = ""
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
                    self.configureButtonStyle(self.nicknameView.checkButton, isEnabled: false)
                    self.nicknameView.notionLabel.textColor = UIColor.primary(.error)
                    self.nicknameView.nextButton.changeState(forState: .isDisabled)
                }
                else if self.whetherDuplicate == false && self.formError(self.nicknameView.textField.text ?? "") == false {
                    self.nicknameView.notionLabel.text = "한글 2~8자, 영어 2~16자 이내로 다시 말씀해주세요."
                    self.nicknameView.notionLabel.textColor = UIColor.primary(.error)
                    self.nicknameView.textField.layer.borderColor = UIColor.primary(.error).cgColor
                }
                else {
                    self.nicknameView.textField.resignFirstResponder()
                    self.nicknameView.notionLabel.text = "좋은 닉네임이에요!"
                    self.nicknameView.notionLabel.textColor = UIColor.grayscale(.gray400)
                    self.configureButtonStyle(self.nicknameView.checkButton, isEnabled: false)
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
}

//MARK: - UITextFieldDelegate

extension NicknameViewController: UITextFieldDelegate {
    
    // return키 눌렀을 때 키보드 내려가게 하는 코드
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        // 백스페이스 처리
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if isBackSpace == -92 {
                return true
            }
        }
        guard let range = Range(range, in: textField.text!) else { return false }
        let currentText = textField.text!
        let newText = currentText.replacingCharacters(in: range, with: string)
        
        //입력된 텍스트의 byte 길이를 계산한 후 최대 바이트 길이인 16을 초과하는 경우에만 입력을 막는 코드
        let byteLength = newText.eucKrByteLength
        
        if byteLength > 16 {
            return false
        } else {
            return true
        }
    }
}

