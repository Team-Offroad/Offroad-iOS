//
//  CharacterChatLogView.swift
//  Offroad-iOS
//
//  Created by 김민성 on 11/12/24.
//

import UIKit

class CharacterChatLogView: UIView {
    
    //MARK: - Properties
    
    private var layout: UICollectionViewLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.estimatedItemSize = .init(width: UIScreen.currentScreenSize.width, height: 44)
        return layout
    }
    
    //MARK: - UI Properties
    
    let backgroundView: UIView
    private let blurShadeView = UIView().then { $0.backgroundColor = .black.withAlphaComponent(0.2) }
    private let blurEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
    private let customNavigationBar = UIView()
    let backButton = UIButton()
    private let customNavigationTitleLabel = UILabel()
    
    lazy var chatLogCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
    private let chatButton = UIButton()
    private let userChatView = UIView()
    private let userChatInputView = UITextView()
    private let sendButton = UIButton()
    
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
        
        chatLogCollectionView.snp.makeConstraints { make in
            make.top.equalTo(customNavigationBar.snp.bottom)
            make.horizontalEdges.equalToSuperview()
        }
        
        chatButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(chatLogCollectionView.snp.bottom).offset(27.7)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(67.3)
            make.width.equalTo(94)
            make.height.equalTo(40)
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
            collectionView.register(CharacterChatLogHeader.self, forSupplementaryViewOfKind: "UICollectionElementKindSectionHeader", withReuseIdentifier: UICollectionView.elementKindSectionHeader)
        }
        
        chatButton.do { button in
            button.setTitle("채팅하기", for: .normal)
            button.roundCorners(cornerRadius: 12)
            button.configureBackgroundColorWhen(
                normal: .primary(.white).withAlphaComponent(0.33),
                highlighted: .primary(.white).withAlphaComponent(0.55)
            )
        }
        
    }
    
    private func setupHierarchy() {
        addSubviews(backgroundView, blurShadeView, blurEffectView, customNavigationBar, chatLogCollectionView, chatButton)
        customNavigationBar.addSubviews(backButton, customNavigationTitleLabel)
    }
    
}

