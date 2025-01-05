//
//  ORBCharacterChatView.swift
//  Offroad-iOS
//
//  Created by 김민성 on 11/7/24.
//

import UIKit

import Lottie
import RxSwift
import RxCocoa

final class ORBCharacterChatView: UIView {
    
    //MARK: - Properties
    
    lazy var characterChatBoxTopConstraint = characterChatBox.topAnchor.constraint(equalTo: topAnchor)
    lazy var userChatViewBottomConstraint = userChatView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 160)
    lazy var userChatInputViewHeightConstraint = userChatInputView.heightAnchor.constraint(equalToConstant: 37)
    lazy var userChatDisplayViewHeightConstraint = userChatDisplayView.heightAnchor.constraint(equalToConstant: 24)
    
    //MARK: - UI Properties
    
    let characterChatBox = ORBCharacterChatBox(mode: .withoutReplyButtonShrinked)
    let userChatView = UIView()
    
    let meLabel = UILabel()
    let loadingAnimationView = LottieAnimationView(name: "loading2")
    let userChatDisplayView = UITextView()
    let userChatInputView = UITextView()
    let keyboardBackgroundView = UIView()
    let sendButton = ShrinkableButton(shrinkScale: 0.9)
    let endChatButton = ShrinkableButton(shrinkScale: 0.93)
    
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
        characterChatBoxTopConstraint.constant = -(150)
        characterChatBoxTopConstraint.isActive = true
        characterChatBox.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.greaterThanOrEqualTo(58)
        }
        
        userChatViewBottomConstraint.isActive = true
        userChatView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
        }
        
        meLabel.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        meLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(16)
            make.leading.equalToSuperview().inset(38)
        }
        
        loadingAnimationView.snp.makeConstraints { make in
            make.centerY.equalTo(meLabel)
            make.leading.equalTo(meLabel).offset(4.2)
            make.height.equalTo(50)
            make.width.equalTo(100)
        }
        
        userChatDisplayView.setContentHuggingPriority(.defaultLow, for: .horizontal)
        userChatDisplayViewHeightConstraint.isActive = true
        userChatDisplayView.snp.makeConstraints { make in
            make.top.equalTo(meLabel)
            make.leading.equalTo(meLabel.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(24)
        }
        
        userChatInputViewHeightConstraint.isActive = true
        userChatInputView.snp.makeConstraints { make in
            make.top.equalTo(userChatDisplayView.snp.bottom).offset(12)
            make.leading.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().inset(16)
        }
        
        keyboardBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(userChatView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        sendButton.snp.makeConstraints { make in
            make.centerY.equalTo(userChatInputView)
            make.leading.equalTo(userChatInputView.snp.trailing).offset(7)
            make.trailing.equalToSuperview().inset(24)
            make.size.equalTo(40)
        }
        
        endChatButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(24)
            make.bottom.equalTo(userChatView.snp.top).offset(-12)
            make.width.equalTo(84)
            make.height.equalTo(36)
        }
    }
    
    //MARK: - Private Func
    
    private func setupStyle() {
        userChatView.do { view in
            view.backgroundColor = .primary(.white)
            view.roundCorners(cornerRadius: 20, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
            view.layer.shadowColor = UIColor.primary(.black).cgColor
            view.layer.shadowOffset = .zero
            view.layer.shadowOpacity = 0.2
            view.layer.shadowRadius = 10
            view.layer.masksToBounds = false
        }
        meLabel.do { label in
            label.textColor = .main(.main2)
            label.font = .pretendardFont(ofSize: 16, weight: .regular)
            label.text = "나 :"
            label.highlightText(targetText: " ", font: .pretendardFont(ofSize: 16, weight: .medium))
            label.highlightText(targetText: "나", font: .pretendardFont(ofSize: 16, weight: .bold))
            label.setLineHeight(percentage: 150)
        }
        loadingAnimationView.do { animationView in
            animationView.isHidden = true
            animationView.contentMode = .scaleAspectFit
            animationView.loopMode = .loop
        }
        userChatDisplayView.do { textView in
            textView.textColor = .main(.main2)
            textView.font = .offroad(style: .iosText)
            textView.backgroundColor = .clear
            textView.isSelectable = false
            textView.textContainerInset = .zero
            textView.textContainer.lineFragmentPadding = 0
            textView.showsVerticalScrollIndicator = false
        }
        userChatInputView.do { textView in
            textView.textColor = .main(.main2)
            textView.font = .offroad(style: .iosText)
            textView.backgroundColor = .neutral(.btnInactive)
            textView.contentInset = .init(top: 9, left: 0, bottom: 9, right: 0)
            textView.textContainerInset = .init(top: 0, left: 20, bottom: 0, right: 20)
            textView.textContainer.lineFragmentPadding = 0
            textView.showsVerticalScrollIndicator = false
            textView.roundCorners(cornerRadius: 12)
        }
        keyboardBackgroundView.do { view in
            view.backgroundColor = .primary(.white)
            view.isHidden = true
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
            button.configureBackgroundColorWhen(normal: .sub(.sub55), highlighted: .sub(.sub))
        }
    }
    
    private func setupHierarchy() {
        userChatView.addSubviews(meLabel, userChatDisplayView, loadingAnimationView, userChatInputView, sendButton)
        addSubviews(characterChatBox, userChatView, keyboardBackgroundView, endChatButton)
    }
    
}
