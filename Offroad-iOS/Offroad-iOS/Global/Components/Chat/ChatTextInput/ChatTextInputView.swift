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
    
    /// 입력창에 텍스트가 바뀔 때마다 입력된 텍스트를 방출하는 `Observable` 스트림.
    var onTextInput: Observable<String> { inputTextRelay.asObservable() }
    /// 사용자가 전송 버튼을 눌렀을 때 입력된 텍스트를 방출하는 `Observable` 스트림.
    var onSendingText: Observable<String> { sendingTextRelay.asObservable() }
    /// 현재 텍스트 전송이 가능한지 여부를 나타내는 속성.
    ///
    /// `true`인 경우, 텍스트 입력창이 비어있지 않을 때 전송 버튼이 활성화됨.
    ///
    /// `false` 인 경우, 텍스트 입력창이 비어있지 않아도 전송 버튼이 비활성화됨.
    var isSendingAllowed: Bool = true {
        didSet {
            let isTextViewEmpty = userChatInputView.text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            if isSendingAllowed && !isTextViewEmpty {
                    sendButton.isEnabled = true
            }
        }
    }
    
    private let inputTextRelay = PublishRelay<String>()
    private let sendingTextRelay = PublishRelay<String>()
    private let showingAnimator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 1)
    private let hidingAnimator = UIViewPropertyAnimator(duration: 0.3, dampingRatio: 1)
    
    private var disposeBag = DisposeBag()
    
    private lazy var userChatInputViewHeightConstraint = userChatInputView.heightAnchor.constraint(equalToConstant: 19 + 9*2)
    
    //MARK: - UI Properties
    
    private let userChatInputView = UITextView()
    private let textViewBackground = UIView()
    private let sendButton = ShrinkableButton(shrinkScale: 0.9)
    
    //MARK: - Life Cycle
    
    public init() {
        super.init(frame: .zero)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupActions()
        userChatInputView.delegate = self
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - Private Extensions

private extension ChatTextInputView {
    
    //MARK: - Layout Func
    
    private func setupLayout() {
        textViewBackground.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(16)
            make.leading.equalToSuperview().inset(24)
        }
        
        userChatInputViewHeightConstraint.isActive = true
        userChatInputView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        sendButton.snp.makeConstraints { make in
            make.centerY.equalTo(userChatInputView)
            make.leading.equalTo(textViewBackground.snp.trailing).offset(7)
            make.trailing.equalToSuperview().inset(24)
            make.size.equalTo(40)
        }
    }
    
    //MARK: - Private Func
    
    private func setupStyle() {
        backgroundColor = .primary(.white)
        
        textViewBackground.do { view in
            view.backgroundColor = .neutral(.btnInactive)
            view.roundCorners(cornerRadius: 12)
        }
        
        userChatInputView.do { textView in
            textView.backgroundColor = .clear
            textView.textColor = .main(.main2)
            textView.font = .offroad(style: .iosTextAuto)
            textView.textContainerInset = .init(top: 9, left: 0, bottom: 9, right: 0)
            textView.textContainer.lineFragmentPadding = 0
            textView.indicatorStyle = .black
            textView.clipsToBounds = false
            textView.verticalScrollIndicatorInsets = .init(top: 0, left: 0, bottom: 0, right: -10)
        }
        
        sendButton.do { button in
            button.setImage(.icnChatViewSendButton, for: .normal)
        }
    }
    
    private func setupHierarchy() {
        addSubviews(textViewBackground, sendButton)
        textViewBackground.addSubview(userChatInputView)
    }
    
    private func setupActions() {
        // 텍스트가 변할 때마다 외부로 텍스트 방출
        userChatInputView.rx.text.orEmpty.bind(to: inputTextRelay).disposed(by: disposeBag)
        // 텍스트가 변화를 구독
        userChatInputView.rx.text.orEmpty
            .asDriver()
            .drive(onNext: { [weak self] text in
                guard let self else { return }
                
                // 입력창이 비어있으면 전송 버튼 비활성화
                self.sendButton.isEnabled =
                !text.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && isSendingAllowed
                
                // 텍스트 줄 수에 따라 입력창 높이 설정
                let textContentHeight = self.userChatInputView.contentSize.height
                self.updateChatInputViewHeight(height: min(textContentHeight, (19*2) + 9*2))
                self.layoutIfNeeded()
            }).disposed(by: disposeBag)
        
        // sendButton의 탭 이벤트 구독
        sendButton.rx.tap.subscribe(onNext: { [weak self] _ in
            guard let self else { return }
            let currentText = self.userChatInputView.text ?? ""
            guard !currentText.isEmpty else { return }
            self.userChatInputView.text = ""
            self.isSendingAllowed = false
            self.sendButton.isEnabled = false
            AmplitudeManager.shared.trackEvent(withName: AmplitudeEventTitles.chatMessageSent)
            sendingTextRelay.accept(currentText)
        }).disposed(by: disposeBag)
    }
    
    private func updateChatInputViewHeight(height: CGFloat) {
        UIView.animate(
            withDuration: 0.4,
            delay: 0,
            usingSpringWithDamping: 1,
            initialSpringVelocity: 1
        ) { [weak self] in
            self?.userChatInputView.setNeedsLayout()
            self?.userChatInputView.layoutIfNeeded()
            self?.userChatInputViewHeightConstraint.constant = height
            self?.superview?.layoutIfNeeded()
        }
    }
    
    private func show(animated: Bool = true) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.hidingAnimator.stopAnimation(true)
            self.showingAnimator.stopAnimation(true)
            if animated {
                self.showingAnimator.addAnimations { [weak self] in self?.alpha = 1 }
                self.showingAnimator.startAnimation()
            } else {
                self.alpha = 1
            }
        }
    }
    
    private func hide(animated: Bool = true, completion: (() -> Void)? = nil) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.showingAnimator.stopAnimation(true)
            self.hidingAnimator.stopAnimation(true)
            if animated {
                hidingAnimator.addAnimations { [weak self] in self?.alpha = 0 }
                hidingAnimator.addCompletion { _ in completion?() }
                hidingAnimator.startAnimation()
            } else {
                self.alpha = 0
            }
        }
    }
    
}

//MARK: - Public Extensions

public extension ChatTextInputView {
    
    //MARK: - Func
    
    /// 채팅을 시작하는 함수.
    /// - 채팅 입력창을 화면에 표시하고 `firstResponder`로 설정함.
    func startChat() {
        show()
        userChatInputView.becomeFirstResponder()
    }
    
    /// 채팅을 종료하는 함수. 화면에서 채팅 입력창을 숨기고 `firstResponder`를 resign함.
    /// - Parameters:
    ///   - erase: 화면에서 숨겨진 후 입력창에 입력된 텍스트를 제거할 지 여부. `true`를 할당하면 완전히 숨겨진 후 텍스트를 지우고, `false`를 할당하면 숨겨진 후에도 텍스트를 유지하여 다음 표시 때 입력된 텍스트를 여전히 띄움.
    ///   - completion: 숨겨진 후 실행할 콜백 함수. 매개변수가 없는 클로저 타입임.
    func endChat(erase: Bool = false, completion: (() -> Void)? = nil) {
        hide { [weak self] in
            if erase { self?.userChatInputView.text = "" }
            completion?()
        }
        userChatInputView.resignFirstResponder()
    }
    
}

extension ChatTextInputView: UITextViewDelegate {
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        guard scrollView == userChatInputView else { return }
        // 텍스트뷰에 글을 붙여넣기 하는 경우 추가된 텍스트의 마지막 부분(==커서의 위치)로 텍스트뷰의 스크롤 위치 자동으로 이동함.
        // 그러나 긴 글을 붙여넣기 하는 경우..애니메이션이 끝나도 커서가 텍스트뷰의 bounds 안에 들어오지 않는 경우 발생.
        // -> 커서의 위치를 이동하는 함수를 UITextView의 extension으로 만들고 비동기로 호출하여 해결 (그냥 호출하는것도 안됨..)
        DispatchQueue.main.async {
            (scrollView as! UITextView).scrollToCursorPosition(animated: false)
        }
    }
    
}
