//
//  ORBCharacterChatView.swift
//  Offroad-iOS
//
//  Created by 김민성 on 11/7/24.
//

import UIKit

final class ORBCharacterChatView: UIView {
    
    //MARK: - Properties
    
    let characterChatBoxShowingAnimator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 1)
    let characterChatBoxHidingAnimator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 1)
    let userChatInputViewAnimator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 1)
    
    lazy var characterChatBoxTopConstraint = characterChatBox.topAnchor.constraint(equalTo: topAnchor, constant: 74)
    lazy var characterChatBoxBottomConstraint = characterChatBox.bottomAnchor.constraint(equalTo: topAnchor)
    lazy var userChatInputViewBottomConstraint = userChatInputView.bottomAnchor.constraint(equalTo: bottomAnchor)
    lazy var inputTextViewHeightConstraint = inputTextView.heightAnchor.constraint(equalToConstant: 40)
    
    //MARK: - UI Properties
    
    let characterChatBox = ORBCharacterChatBox()
    let userChatInputView = UIView()
    
    let meLabel = UILabel()
    let inputTextLabel = UILabel()
    let inputTextView = UITextView()
    let sendButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        
        inputTextLabel.snp.makeConstraints { make in
            make.top.equalTo(meLabel)
            make.leading.equalTo(meLabel.snp.trailing)
            make.trailing.equalToSuperview().inset(24)
        }
        
        inputTextViewHeightConstraint.isActive = true
        inputTextView.snp.makeConstraints { make in
            make.top.equalTo(meLabel.snp.bottom).offset(12)
            make.leading.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().inset(16)
        }
        
        sendButton.snp.makeConstraints { make in
            make.top.equalTo(inputTextView)
            make.leading.equalTo(inputTextView.snp.trailing).offset(7)
            make.trailing.equalToSuperview().inset(24)
            make.size.equalTo(40)
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
            label.text = "나:"
            label.highlightText(targetText: " ", font: .pretendardFont(ofSize: 16, weight: .medium))
            label.highlightText(targetText: "나", font: .pretendardFont(ofSize: 16, weight: .bold))
            label.setLineHeight(percentage: 150)
        }
        inputTextLabel.do { label in
            label.textColor = .main(.main2)
            label.font = .offroad(style: .iosText)
        }
        inputTextView.do { textView in
            textView.textColor = .main(.main2)
            textView.font = .offroad(style: .iosText)
            textView.backgroundColor = .neutral(.btnInactive)
//            textView.contentInset = .init(top: 9, left: 20, bottom: 9, right: 20)
            textView.contentInset = .init(top: 9, left: 0, bottom: 9, right: 0)
            textView.textContainerInset = .init(top: 0, left: 0, bottom: 0, right: 0)
            textView.textInputView.backgroundColor = .orange
            textView.roundCorners(cornerRadius: 12)
        }
        sendButton.do { button in
            button.setImage(.icnChatViewSendButton, for: .normal)
        }
    }
    
    private func setupHierarchy() {
        userChatInputView.addSubviews(meLabel, inputTextLabel, inputTextView, sendButton)
        addSubviews(characterChatBox, userChatInputView)
    }
    
    //MARK: - Func
    
    
    
}
