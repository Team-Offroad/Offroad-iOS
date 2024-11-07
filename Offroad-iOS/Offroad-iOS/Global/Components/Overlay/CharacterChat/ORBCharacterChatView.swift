//
//  ORBCharacterChatView.swift
//  Offroad-iOS
//
//  Created by 김민성 on 11/7/24.
//

import UIKit

final class ORBCharacterChatView: UIView {
    
    //MARK: - Properties
    
    let characterChatBoxShowingAnimator = UIViewPropertyAnimator(duration: 0.3, dampingRatio: 1)
    let characterChatBoxHidingAnimator = UIViewPropertyAnimator(duration: 0.3, dampingRatio: 1)
    
    lazy var characterChatBoxTopConstraint = characterChatBox.topAnchor.constraint(equalTo: topAnchor, constant: 74)
    lazy var characterChatBoxBottomConstraint = characterChatBox.bottomAnchor.constraint(equalTo: topAnchor)
    
    //MARK: - UI Properties
    
    let characterChatBox = ORBCharacterChatBox()
    let userChatInputAccessoryView = UIView()
    
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
    }
    
    //MARK: - Private Func
    
    private func setupStyle() {
        userChatInputAccessoryView.do { view in
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
            textView.backgroundColor = .neutral(.btnInactive)
            textView.roundCorners(cornerRadius: 12)
        }
        sendButton.do { button in
            button.setImage(.icnChatViewSendButton, for: .normal)
        }
    }
    
    private func setupHierarchy() {
        userChatInputAccessoryView.addSubviews(meLabel, inputTextLabel, inputTextView, sendButton)
        addSubviews(characterChatBox, userChatInputAccessoryView)
    }
    
    //MARK: - Func
    
    func showCharacterChatBox() {
        characterChatBoxHidingAnimator.stopAnimation(true)
        characterChatBoxShowingAnimator.addAnimations { [weak self] in
            guard let self else { return }
            self.characterChatBoxTopConstraint.isActive = true
            self.characterChatBoxBottomConstraint.isActive = false
        }
        characterChatBoxShowingAnimator.startAnimation()
    }
    
    func hideCharacterChatBox() {
        characterChatBoxShowingAnimator.stopAnimation(true)
        characterChatBoxHidingAnimator.addAnimations { [weak self] in
            guard let self else { return }
            self.characterChatBoxTopConstraint.isActive = false
            self.characterChatBoxBottomConstraint.isActive = true
        }
        characterChatBoxHidingAnimator.startAnimation()
    }
    
}
