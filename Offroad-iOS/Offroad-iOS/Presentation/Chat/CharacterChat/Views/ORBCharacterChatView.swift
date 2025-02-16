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
    
    //MARK: - UI Properties
    
    let characterChatBox = ORBCharacterChatBox(mode: .withoutReplyButtonShrinked)
    let chatTextInputView = ChatTextInputView()
    let chatTextDisplayView = ChatTextDisplayView()
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
        
        chatTextInputView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        chatTextDisplayView.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(chatTextInputView)
            // 두 뷰를 딱 붙여놓으니, 애니메이션 과정에서 경계선이 약간 보이는 문제가 있어 1포인트만큼 겹쳐놓았음.
            make.bottom.equalTo(chatTextInputView.snp.top).offset(1)
        }
        
        endChatButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(24)
            make.bottom.equalTo(chatTextDisplayView.snp.top).offset(-12)
            make.width.equalTo(84)
            make.height.equalTo(36)
        }
    }
    
    //MARK: - Private Func
    
    private func setupStyle() {
        chatTextInputView.do { view in
            view.alpha = 0
        }
        
        chatTextDisplayView.do { view in
            view.alpha = 0
            view.roundCorners(cornerRadius: 20, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
            view.layer.shadowColor = UIColor.primary(.black).cgColor
            view.layer.shadowOffset = .zero
            view.layer.shadowOpacity = 0.2
            view.layer.shadowRadius = 10
            view.layer.masksToBounds = false
        }
        
        endChatButton.do { button in
            button.backgroundColor = .sub(.sub55)
            button.layer.borderColor = UIColor.sub(.sub).cgColor
            button.layer.borderWidth = 1
            button.setTitle("채팅 종료", for: .normal)
            button.roundCorners(cornerRadius: 18)
            button.configureTitleFontWhen(normal: .offroad(style: .iosTextContents))
            button.configureBackgroundColorWhen(normal: .sub(.sub55), highlighted: .sub(.sub))
            button.configuration?.baseForegroundColor = .primary(.white)
        }
    }
    
    private func setupHierarchy() {
        addSubviews(characterChatBox, chatTextDisplayView, chatTextInputView, endChatButton)
    }
    
}
