//
//  ORBRecommendationChatView.swift
//  ORB_Dev
//
//  Created by 김민성 on 5/4/25.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit
import Then

final class ORBRecommendationChatView: ORBRecommendationChatBackgroundView {
    
    // MARK: - Properties
    
    // 다른 앱으로 나갔다 들어왔을 때 keyboardWillShow 메서드가 한 번 더 호출됨.
    // 이로 인해 채팅 목록이 의도치 않게 위로 더 올라가는 문제를 막기 위해 사용되는 flag.
    private var isKeyboardShown: Bool = false
    private var disposeBag = DisposeBag()
    
    // MARK: - UI Properties
    
    private(set) var xButton = UIButton()
    private(set) var collectionView: UICollectionView! = nil
    private(set) var exampleQuestionListView = ORBRecommendationChatExampleQuestionListView()
    private(set) var chatInputView = ChatTextInputView()
    private let keyboardBackgroundView = UIView()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupGestures()
        setupNotification()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// Initial Settings
private extension ORBRecommendationChatView {
    
    func setupStyle() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 0
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.do { collectionView in
            collectionView.backgroundColor = .clear
            collectionView.contentInset = .init(top: 63.5, left: 0, bottom: 20, right: 0)
        }
        
        chatInputView.roundCorners(cornerRadius: 20, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        chatInputView.layer.cornerCurve = .continuous
        
        keyboardBackgroundView.do { view in
            view.backgroundColor = .primary(.white)
        }
        
        xButton.do { button in
            button.setImage(.iconClose, for: .normal)
        }
    }
    
    func setupHierarchy() {
        addSubviews(collectionView, exampleQuestionListView, chatInputView, keyboardBackgroundView, xButton)
    }
    
    func setupLayout() {
        chatInputView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(keyboardLayoutGuide.snp.top)
        }
        
        keyboardBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(chatInputView.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        xButton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(3.3)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(13.7)
            make.size.equalTo(44)
        }
        
        exampleQuestionListView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(chatInputView.snp.top).offset(-15)
            make.height.equalTo(64)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.bottom.equalTo(chatInputView.snp.top)
        }
    }
    
    func setupGestures() {
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event.asDriver().drive { _ in
            self.endEditing(true)
        }.disposed(by: disposeBag)
        collectionView.addGestureRecognizer(tapGesture)
    }
    
    func setupNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillHide),
            name: UIResponder.keyboardWillHideNotification,
            object: nil
        )
    }
    
}

// keyboard 나타나고 사라질 때 동작 관련 메서드들
private extension ORBRecommendationChatView {
    
    @objc func keyboardWillShow(_ notification: Notification) {
        guard !isKeyboardShown else { return }
        if let keyboardFrame = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? CGRect {
            let keyboardHeight = keyboardFrame.height
            let verticalInsets = collectionView.contentInset.top + collectionView.contentInset.bottom
            // 다음 `intersectingHeight`는 화면상에서 `contentView`와 키보드+입력창 이 교차하는 영역의 높이를 계산한 것입니다.
            // 컨텐츠 영역 높이가 충분히 크지 않아 키보드 높이보다 적게 올라가야 하는 경우도 고려하여 수식을 이같이 작성했습니다.
            // 컨텐츠 높이가 충분히 높아 값이 커질 경우 최댓값은 키보드가 올라온 만큼의 높이가 됩니다.
            let intersectingHeightInBounds = (
                safeAreaInsets.top + verticalInsets + collectionView.contentSize.height
                + (chatInputView.frame.height + keyboardHeight)
                - bounds.height
            )
            let minValue: CGFloat = 0
            let maxValue: CGFloat = keyboardHeight - safeAreaInsets.bottom
            collectionView.contentOffset.y += min(max(minValue, intersectingHeightInBounds), maxValue)
            isKeyboardShown = true
        } else {
            assertionFailure("keyboard is about to show but cannot get keyboard frame.")
        }
    }
    
    @objc func keyboardWillHide(_ notification: Notification) {
        isKeyboardShown = false
    }
    
}
