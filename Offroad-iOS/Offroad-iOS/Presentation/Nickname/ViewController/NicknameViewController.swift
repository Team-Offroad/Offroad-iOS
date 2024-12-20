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
import RxSwift
import RxCocoa

final class NicknameViewController: UIViewController {
    
    //MARK: - Properties
    
    private let nicknameView = NicknameView()
    private var whetherDuplicate: Bool = false
    private let disposeBag = DisposeBag()
    
    //MARK: - Life Cycle
    
    override func loadView() {
        view = nicknameView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupDelegate()
        setupBindings()
        view.backgroundColor = UIColor.main(.main1)
        
        self.modalPresentationStyle = .fullScreen
    }
    
    //MARK: - Private Func
    
    private func setupDelegate() {
        nicknameView.nicknameTextField.delegate = self
    }
    
    private func setupBindings() {
        /// RxSwift에서 제공하는 UITextField.rx.text는 .editingChanged 이벤트 + 최초 초기화 1회 + 포커싱 + 언포커싱 될 때 모두 방출된다.
        /// 하지만 기존 코드에서 editingDidBegin, editingDidEnd, editingChanged으로 나뉘었으므로 각각의 상황에 맞게 controlEvent를 나눈다.

        //텍스트 필드 focus 이벤트 바인딩(editingDidBegin,editingDidEnd)
        nicknameView.nicknameTextField.rx.controlEvent([.editingDidBegin])
            .subscribe(onNext: { [weak self] in
                self?.nicknameView.nicknameTextField.layer.borderColor = UIColor.main(.main2).cgColor
            })
            .disposed(by: disposeBag)
        
        nicknameView.nicknameTextField.rx.controlEvent([.editingDidEnd])
            .subscribe(onNext: { [weak self] in
                let isTextFieldEmpty = self?.nicknameView.nicknameTextField.text?.isEmpty ?? true
                self?.nicknameView.nicknameTextField.layer.borderColor = isTextFieldEmpty ? UIColor.grayscale(.gray100).cgColor : UIColor.main(.main2).cgColor
            })
            .disposed(by: disposeBag)
        
        // 텍스트 필드 입력 이벤트 바인딩(기존의 editingChanged)
        nicknameView.nicknameTextField.rx.text.orEmpty
            .distinctUntilChanged()
            .subscribe(onNext: { [weak self] text in
                self?.handleTextFieldChange(text)
            })
            .disposed(by: disposeBag)
        
        // 중복 체크 버튼 이벤트 바인딩
        nicknameView.checkButton.rx.tap
            .subscribe(onNext: { [weak self] in
                self?.checkButtonTapped()
            })
            .disposed(by: disposeBag)
        
        /// 화면 터치 시 키보드 내려가게 하는 코드
        /// 기존 UIKit에선
        ///  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        ///self.view.endEditing(true)
        ///    }로 구현했었는데,
        /// UITapGestureRecognizer를 rx로 바인딩하여 구현하는 것도 가능하다.
        ///
        let tapGesture = UITapGestureRecognizer()
        view.addGestureRecognizer(tapGesture)
        tapGesture.rx.event
            .bind { [weak self] _ in
                self?.view.endEditing(true)
            }
            .disposed(by: disposeBag)
    }
    
    private func handleTextFieldChange(_ text: String) {
        
        let isTextFieldEmpty = text.isEmpty
        configureTextFieldStyle(nicknameView.nicknameTextField, isEmpty: isTextFieldEmpty)
        nicknameView.nextButton.changeState(forState: .isDisabled)
        
        if !formError(text) && !isTextFieldEmpty {
            nicknameView.notionLabel.text = "한글 2~8자, 영어 2~16자 이내로 다시 작성해주세요."
            nicknameView.notionLabel.textColor = UIColor.primary(.errorNew)
            nicknameView.nicknameTextField.layer.borderColor = UIColor.primary(.errorNew).cgColor
            nicknameView.nextButton.changeState(forState: .isDisabled)
            configureButtonStyle(nicknameView.checkButton, isEnabled: false)
        } else if isTextFieldEmpty {
            nicknameView.notionLabel.text = "*한글 2~8자, 영어 2~16자 이내로 작성해주세요."
            nicknameView.notionLabel.textColor = UIColor.grayscale(.gray400)
            nicknameView.notionLabel.font = UIFont.offroad(style: .iosHint)
            nicknameView.nicknameTextField.layer.borderColor = UIColor.main(.main2).cgColor
            configureButtonStyle(nicknameView.checkButton, isEnabled: false)
        } else {
            nicknameView.notionLabel.text = ""
            configureButtonStyle(nicknameView.checkButton, isEnabled: true)
        }
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
    
    private func formError(_ input: String) -> Bool {
        let pattern = "^[A-Za-z가-힣]{2,}$"
        let regex = try? NSRegularExpression(pattern: pattern)
        let eucKrLength = input.eucKrByteLength
        if let _ = regex?.firstMatch(in: input, options: [], range: NSRange(location: 0, length: input.count)),
           eucKrLength >= 2 {
            return true
        }
        return false
    }
    
    @objc private func checkButtonTapped() {
        NetworkService.shared.nicknameService.checkNicknameDuplicate(inputNickname: nicknameView.nicknameTextField.text ?? "") { response in
            switch response {
            case .success(let data):
                self.whetherDuplicate = data?.data.isDuplicate ?? Bool()
                if self.whetherDuplicate == true {
                    self.nicknameView.notionLabel.text = "중복된 닉네임이에요. 다른 멋진 이름이 있으신가요?"
                    self.configureButtonStyle(self.nicknameView.checkButton, isEnabled: false)
                    self.nicknameView.notionLabel.textColor = UIColor.primary(.errorNew)
                    self.nicknameView.nextButton.changeState(forState: .isDisabled)
                }
                else if self.whetherDuplicate == false && self.formError(self.nicknameView.nicknameTextField.text ?? "") == false {
                    self.nicknameView.notionLabel.text = "한글 2~8자, 영어 2~16자 이내로 다시 말씀해주세요."
                    self.nicknameView.notionLabel.textColor = UIColor.primary(.errorNew)
                    self.nicknameView.nicknameTextField.layer.borderColor = UIColor.primary(.errorNew).cgColor
                }
                else {
                    self.nicknameView.nicknameTextField.resignFirstResponder()
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
}

//MARK: - UITextFieldDelegate

extension NicknameViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if let char = string.cString(using: String.Encoding.utf8) {
            let isBackSpace = strcmp(char, "\\b")
            if isBackSpace == -92 {
                return true
            }
        }
        guard let range = Range(range, in: textField.text!) else { return false }
        let currentText = textField.text!
        let newText = currentText.replacingCharacters(in: range, with: string)
        let byteLength = newText.eucKrByteLength
        return byteLength <= 16
    }
}
