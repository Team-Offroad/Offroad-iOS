//
//  ChatTextInputView.swift
//  Offroad-iOS
//
//  Created by 김민성 on 2/8/25.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit

public class ChatTextInputView: UIView {
    
    //MARK: - Properties
    
    var inputTextRelay = PublishRelay<String>()
    var sendingTextRelay = PublishRelay<String>()
    
    private let userChatInputViewHeightRelay = PublishRelay<CGFloat>()
    private let userChatInputViewHeightAnimator = UIViewPropertyAnimator(duration: 0.3, dampingRatio: 1)
    
    private var disposeBag = DisposeBag()
    
    private lazy var userChatInputViewHeightConstraint = userChatInputView.heightAnchor.constraint(equalToConstant: 40)
    
    //MARK: - UI Properties
    
    private let userChatInputView = UITextView()
    private let sendButton = ShrinkableButton(shrinkScale: 0.9)
    
    //MARK: - Life Cycle
    
    public init() {
        super.init(frame: .zero)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}

extension ChatTextInputView {
    
    //MARK: - Layout Func
    
    private func setupLayout() {
        userChatInputViewHeightConstraint.isActive = true
        userChatInputView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(16)
            make.leading.equalToSuperview().inset(24)
        }
        
        sendButton.snp.makeConstraints { make in
            make.centerY.equalTo(userChatInputView)
            make.leading.equalTo(userChatInputView.snp.trailing).offset(7)
            make.trailing.equalToSuperview().inset(24)
            make.size.equalTo(40)
        }
    }
    
    //MARK: - Private Func
    
    private func setupStyle() {
        backgroundColor = .primary(.white)
//        roundCorners(cornerRadius: 18, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        
        userChatInputView.do { textView in
            textView.textColor = .main(.main2)
            textView.font = .offroad(style: .iosTextAuto)
            textView.backgroundColor = .neutral(.btnInactive)
            textView.contentInset = .init(top: 9, left: 0, bottom: 9, right: 0)
            textView.textContainerInset = .init(top: 0, left: 20, bottom: 0, right: 20)
            textView.textContainer.lineFragmentPadding = 0
            textView.showsVerticalScrollIndicator = false
            textView.verticalScrollIndicatorInsets = .init(top: 4, left: 0, bottom: 4, right: 10)
            textView.roundCorners(cornerRadius: 12)
        }
        
        sendButton.do { button in
            button.setImage(.icnChatViewSendButton, for: .normal)
        }
    }
    
    private func setupHierarchy() {
        addSubviews(userChatInputView, sendButton)
    }
    
    private func setupActions() {
        // 텍스트가 변할 때마다 외부로 텍스트 방출
        userChatInputView.rx.text.orEmpty.bind(to: inputTextRelay).disposed(by: disposeBag)
        // 텍스트가 변할 때마다 줄 수를 바탕으로 텍스트뷰의 높이 설정
        userChatInputView.rx.text.orEmpty
            .asDriver()
            .drive(onNext: { [weak self] text in
                guard let self else { return }
                let textContentHeight = self.userChatInputView.textInputView.bounds.height
                let isMultiline: Bool = textContentHeight > 30
                let shortHeight: CGFloat = 19.0 + (9*2)
                let longHeight: CGFloat = (19.0*2) + (9.0*2)
                self.updateChatInputViewHeight(height: isMultiline ? longHeight : shortHeight)
                self.layoutIfNeeded()
            }).disposed(by: disposeBag)
        
        // sendButton을 탭할 경우 외부로 현재 입력된 텍스트 방출
        sendButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self else { return }
            let currentText = self.userChatInputView.text ?? ""
            guard !currentText.isEmpty else { return }
            sendingTextRelay.accept(currentText)
        }).disposed(by: disposeBag)
    }
    
    private func updateChatInputViewHeight(height: CGFloat, animated: Bool = false) {
        userChatInputViewHeightAnimator.stopAnimation(true)
        userChatInputViewHeightAnimator.addAnimations { [weak self] in
            self?.userChatInputViewHeightConstraint.constant = height
            self?.superview?.layoutIfNeeded()
        }
        userChatInputViewHeightAnimator.startAnimation()
    }
    
    
    //MARK: - Func
    
    func startChat() {
        userChatInputView.becomeFirstResponder()
    }
    
    func endChat() {
        userChatInputView.resignFirstResponder()
    }
    
}
