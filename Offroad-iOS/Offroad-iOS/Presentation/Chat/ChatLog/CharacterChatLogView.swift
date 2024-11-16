//
//  CharacterChatLogView.swift
//  Offroad-iOS
//
//  Created by 김민성 on 11/12/24.
//

import UIKit

import Lottie

class CharacterChatLogView: UIView {
    
    //MARK: - Properties
    
    private var layout: UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
//        layout.estimatedItemSize = .init(width: UIScreen.currentScreenSize.width, height: 50)
        return layout
    }
    
    lazy var chatLogCollectionViewBottomConstraint = chatLogCollectionView.bottomAnchor.constraint(equalTo: bottomAnchor)
    lazy var chatButtonBottomConstraint = chatButton.bottomAnchor.constraint(equalTo: bottomAnchor)
    lazy var userChatInputViewHeightConstraint = userChatInputView.heightAnchor.constraint(equalToConstant: 40)
    lazy var userChatViewBottomConstraint = userChatView.bottomAnchor.constraint(equalTo: keyboardLayoutGuide.topAnchor)
    
    //MARK: - UI Properties
    
    let backgroundView: UIView
    let blurShadeView = UIView().then { $0.backgroundColor = .black.withAlphaComponent(0.2) }
    private let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    private let customNavigationBar = UIView()
    let backButton = UIButton()
    private let customNavigationTitleLabel = UILabel()
    
    lazy var chatLogCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    let chatButton = UIButton()
    
    let userChatBoundsView = UIView()
    let userChatView = UIView()
    let userChatInputView = UITextView()
    private let sendButton = UIButton()
    let loadingAnimationView = LottieAnimationView(name: "loading2")
    
    //MARK: - Life Cycle
    
    init(background: UIView) {
        self.backgroundView = background
        super.init(frame: .zero)
        setupStyle()
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        
        endEditing(true)
    }
    
}

extension CharacterChatLogView {
    
    //MARK: - Layout Func
    
    private func setupLayout() {
        backgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        blurShadeView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        blurEffectView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        customNavigationBar.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(10.7)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(44)
        }
        
        backButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().inset(8)
            make.size.equalTo(44)
        }
        
        customNavigationTitleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(4)
            make.centerY.equalToSuperview()
            make.leading.greaterThanOrEqualTo(backButton.snp.trailing).offset(8)
            make.trailing.lessThanOrEqualToSuperview().inset(8)
        }
        
        chatLogCollectionViewBottomConstraint.isActive = true
        chatLogCollectionView.snp.makeConstraints { make in
            make.top.equalTo(customNavigationBar.snp.bottom)
            make.horizontalEdges.equalToSuperview()
        }
        
        chatButtonBottomConstraint.isActive = true
        chatButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(94)
            make.height.equalTo(40)
        }
        
        userChatBoundsView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(keyboardLayoutGuide.snp.top)
        }
        
        userChatView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
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
        backButton.do({ button in
            button.setImage(.backBarButton, for: .normal)
            button.tintColor = .main(.main1)
        })
        
        customNavigationTitleLabel.do { label in
            label.textColor = .main(.main1)
            label.font = .offroad(style: .iosTextBold)
            label.textAlignment = .center
        }
        
        chatLogCollectionView.do { collectionView in
            collectionView.backgroundColor = .clear
            collectionView.register(CharacterChatLogCell.self, forCellWithReuseIdentifier: CharacterChatLogCell.className)
            collectionView.register(
                CharacterChatLogHeader.self,
                forSupplementaryViewOfKind: "UICollectionElementKindSectionHeader",
                withReuseIdentifier: UICollectionView.elementKindSectionHeader
            )
            collectionView.contentInsetAdjustmentBehavior = .automatic
            collectionView.contentInset.bottom += 135
            collectionView.showsVerticalScrollIndicator = false
            collectionView.keyboardDismissMode = .onDrag
        }
        
        chatButton.do { button in
            button.setTitle("채팅하기", for: .normal)
            button.isUserInteractionEnabled = false
            button.roundCorners(cornerRadius: 12)
            button.configureBackgroundColorWhen(
                normal: .primary(.white).withAlphaComponent(0.33),
                highlighted: .primary(.white).withAlphaComponent(0.55)
            )
        }
        
        userChatBoundsView.do { view in
            view.isUserInteractionEnabled = false
            view.bounds.origin.y = -150
        }
        
        userChatView.do { view in
            view.backgroundColor = .primary(.white)
            view.roundCorners(cornerRadius: 18, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        }
        
        userChatInputView.do { textView in
            textView.textColor = .main(.main2)
            textView.font = .offroad(style: .iosTextAuto)
            textView.backgroundColor = .neutral(.btnInactive)
            textView.contentInset = .init(top: 9, left: 0, bottom: 9, right: 0)
            textView.textContainerInset = .init(top: 0, left: 20, bottom: 0, right: 20)
            textView.textContainer.lineFragmentPadding = 0
            textView.showsVerticalScrollIndicator = false
            textView.roundCorners(cornerRadius: 12)
        }
        
        sendButton.do { button in
            button.setImage(.icnChatViewSendButton, for: .normal)
        }
    }
    
    private func setupHierarchy() {
        addSubviews(
            backgroundView,
            blurShadeView,
            blurEffectView,
            customNavigationBar,
            chatLogCollectionView,
            chatButton,
            userChatBoundsView
        )
        customNavigationBar.addSubviews(backButton, customNavigationTitleLabel)
        userChatBoundsView.addSubview(userChatView)
        userChatView.addSubviews(userChatInputView, sendButton)
    }
    
}

