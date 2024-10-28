//
//  ORBAlertViewAcquiredEmblem.swift
//  Offroad-iOS
//
//  Created by 김민성 on 10/20/24.
//

import UIKit

final class ORBAlertViewAcquiredEmblem: ORBAlertBaseView, ORBAlertViewBaseUI {
    
    let contentView = UIView()
    var type = ORBAlertType.acquiredEmblem
    
    let changeEmblemButton = StateToggleButton(state: .isDisabled, title: "바꾸기")
    
    lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.estimatedItemSize = CGSize(
            width: UIScreen.currentScreenSize.width - (22.5 * 2) - leftInset - rightInset,
            height: 48)
        layout.minimumLineSpacing = 12
        
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.className)
        return collectionView
    }()
    
    override func setupStyle() {
        super.setupStyle()
        
        collectionView.backgroundColor = .clear
    }
    
    override func setupHierarchy() {
        addSubviews(contentView, closeButton)
        contentView.addSubviews(titleLabel, collectionView, changeEmblemButton)
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        contentView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(topInset)
            make.leading.equalToSuperview().inset(leftInset)
            make.trailing.equalToSuperview().inset(rightInset)
            make.bottom.equalToSuperview().inset(bottomInset)
            make.height.greaterThanOrEqualTo(370)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(26)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(254)
        }
        
        changeEmblemButton.snp.makeConstraints { make in
            make.top.equalTo(collectionView.snp.bottom).offset(12)
            make.horizontalEdges.bottom.equalToSuperview()
            make.height.equalTo(54)
        }
    }
    
}
