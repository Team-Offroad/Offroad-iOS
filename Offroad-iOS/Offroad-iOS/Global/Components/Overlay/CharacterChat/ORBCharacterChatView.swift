//
//  ORBCharacterChatView.swift
//  Offroad-iOS
//
//  Created by 김민성 on 11/7/24.
//

import UIKit

import RxSwift
import RxCocoa

final class ORBCharacterChatView: UIView {
    
    //MARK: - Properties
    
    let characterChatBoxAnimator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 1)
    let userChatInputViewAnimator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 1)
    let userChatInputViewHeightAnimator = UIViewPropertyAnimator(duration: 0.3, dampingRatio: 1)
    
    lazy var characterChatBoxTopConstraint = characterChatBox.topAnchor.constraint(equalTo: topAnchor, constant: 74)
    lazy var characterChatBoxBottomConstraint = characterChatBox.bottomAnchor.constraint(equalTo: topAnchor)
    lazy var userChatInputViewBottomConstraint = userChatInputView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 160)
    lazy var inputTextViewHeightConstraint = userChatTextView.heightAnchor.constraint(equalToConstant: 38)
    
    //MARK: - UI Properties
    
    let characterChatBox = ORBCharacterChatBox()
    let userChatInputView = UIView()
    
    let meLabel = UILabel()
    let userChatTextLabel = UILabel()
    let userChatTextView = UITextView()
    let sendButton = UIButton()
    let endChatButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func endEditing(_ force: Bool) -> Bool {
        super.endEditing(force)
    }
    
}


extension ORBCharacterChatView {
    
    //MARK: - Layout Func
    
    private func setupLayout() {
        characterChatBoxTopConstraint.isActive = false
        characterChatBoxBottomConstraint.isActive = true
        characterChatBox.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.greaterThanOrEqualTo(58)
        }
        
        userChatInputViewBottomConstraint.isActive = true
        userChatInputView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
        }
        
        meLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.leading.equalToSuperview().inset(38)
        }
        
        userChatTextLabel.snp.makeConstraints { make in
            make.top.equalTo(meLabel)
            make.leading.equalTo(meLabel.snp.trailing)
            make.trailing.equalToSuperview().inset(24)
        }
        
        inputTextViewHeightConstraint.isActive = true
        userChatTextView.snp.makeConstraints { make in
            make.top.equalTo(meLabel.snp.bottom).offset(12)
            make.leading.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().inset(16)
        }
        
        sendButton.snp.makeConstraints { make in
            make.centerY.equalTo(userChatTextView)
            make.leading.equalTo(userChatTextView.snp.trailing).offset(7)
            make.trailing.equalToSuperview().inset(24)
            make.size.equalTo(40)
        }
        
        endChatButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(24)
            make.bottom.equalTo(userChatInputView.snp.top).offset(-12)
            make.width.equalTo(84)
            make.height.equalTo(36)
        }
    }
    
    //MARK: - Private Func
    
    private func setupStyle() {
        userChatInputView.do { view in
            view.backgroundColor = .primary(.white)
            view.roundCorners(cornerRadius: 20, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        }
        meLabel.do { label in
            label.textColor = .main(.main2)
            label.font = .pretendardFont(ofSize: 16, weight: .regular)
            label.text = "나 :"
            label.highlightText(targetText: " ", font: .pretendardFont(ofSize: 16, weight: .medium))
            label.highlightText(targetText: "나", font: .pretendardFont(ofSize: 16, weight: .bold))
            label.setLineHeight(percentage: 150)
        }
        userChatTextLabel.do { label in
            label.textColor = .main(.main2)
            label.font = .offroad(style: .iosText)
        }
        userChatTextView.do { textView in
            textView.textColor = .main(.main2)
            textView.font = .offroad(style: .iosText)
            textView.backgroundColor = .neutral(.btnInactive)
            textView.contentInset = .init(top: 9, left: 0, bottom: 9, right: 0)
            textView.textContainerInset = .init(top: 0, left: 20, bottom: 0, right: 20)
            textView.textContainer.lineFragmentPadding = 0
            textView.roundCorners(cornerRadius: 12)
        }
        sendButton.do { button in
            button.setImage(.icnChatViewSendButton, for: .normal)
        }
        endChatButton.do { button in
            button.backgroundColor = .sub(.sub55)
            button.layer.borderColor = UIColor.sub(.sub).cgColor
            button.layer.borderWidth = 1
            button.setTitle("채팅 종료", for: .normal)
            button.roundCorners(cornerRadius: 18)
            button.configureTitleFontWhen(normal: .offroad(style: .iosTextContents))
            button.configureBackgroundColorWhen(normal: .sub(.sub55), highlighted: .sub(.sub480))
        }
    }
    
    private func setupHierarchy() {
        userChatInputView.addSubviews(meLabel, userChatTextLabel, userChatTextView, sendButton)
        addSubviews(characterChatBox, userChatInputView, endChatButton)
    }
    
    //MARK: - Func
    
    
    
}
