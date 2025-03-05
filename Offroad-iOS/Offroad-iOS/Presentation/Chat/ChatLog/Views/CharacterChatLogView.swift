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
    
    private let collectionViewInsetAnimator = UIViewPropertyAnimator(duration: 0.5, dampingRatio: 1)
    private let verticalFlipTransform = CGAffineTransform(scaleX: 1, y: -1)
    
    private var layout: UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.footerReferenceSize = .init(width: UIScreen.currentScreenSize.width, height: 25)
        layout.sectionInset = .init(top: 22, left: 0, bottom: 22, right: 0)
        return layout
    }
    
    lazy var chatButtonBottomConstraint = chatButton.bottomAnchor.constraint(equalTo: bottomAnchor)
    
    //MARK: - UI Properties
    
    let backgroundView: UIView
    let blurShadeView = UIView().then { $0.backgroundColor = .black.withAlphaComponent(0.2) }
    private let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    private let customNavigationBar = UIView()
    let backButton = UIButton()
    private let customNavigationTitleLabel = UILabel()
    
    lazy var chatLogCollectionView = ScrollLoadingCollectionView(frame: .zero, collectionViewLayout: layout)
    let chatButton = ShrinkableButton(shrinkScale: 0.9)
    let chatTextInputView = ChatTextInputView()
    
    
    //MARK: - Life Cycle
    
    init(background: UIView, characterName: String) {
        self.backgroundView = background
        self.customNavigationTitleLabel.text = characterName
        super.init(frame: .zero)
        setupStyle()
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview()
            make.leading.greaterThanOrEqualTo(backButton.snp.trailing).offset(8)
            make.trailing.lessThanOrEqualToSuperview().inset(8)
        }
        
        chatLogCollectionView.snp.makeConstraints { make in
            make.top.equalTo(customNavigationBar.snp.bottom)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
        chatButtonBottomConstraint.isActive = true
        chatButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(94)
            make.height.equalTo(40)
        }
        
        chatTextInputView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
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
            collectionView.contentInsetAdjustmentBehavior = .never
            collectionView.transform = verticalFlipTransform
        }
        
        chatButton.do { button in
            button.setTitle("채팅하기", for: .normal)
            button.isUserInteractionEnabled = false
            button.roundCorners(cornerRadius: 12)
            button.configureTitleFontWhen(normal: .offroad(style: .iosText))
            button.configureBackgroundColorWhen(
                normal: .primary(.white).withAlphaComponent(0.33),
                highlighted: .primary(.white).withAlphaComponent(0.55)
            )
            button.configuration?.baseForegroundColor = .primary(.white)
        }
        
        chatTextInputView.do { view in
            view.alpha = 0
            view.roundCorners(cornerRadius: 18, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
            view.layer.shadowColor = UIColor.primary(.black).cgColor
            view.layer.shadowOffset = .zero
            view.layer.shadowOpacity = 0.1
            view.layer.shadowRadius = 10
            view.layer.masksToBounds = false   
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
            chatTextInputView
        )
        customNavigationBar.addSubviews(backButton, customNavigationTitleLabel)
    }
    
    //MARK: - Func
    
    func setChatCollectionViewInset(inset: CGFloat, animated: Bool = true) {
        collectionViewInsetAnimator.stopAnimation(true)
        if animated {
            collectionViewInsetAnimator.addAnimations { [weak self] in
                self?.chatLogCollectionView.contentInset.top = inset
            }
            collectionViewInsetAnimator.startAnimation()
        } else {
            chatLogCollectionView.contentInset.top = inset
        }
    }
    
}

