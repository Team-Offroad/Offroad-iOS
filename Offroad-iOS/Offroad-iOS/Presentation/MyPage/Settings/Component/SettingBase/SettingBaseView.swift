//
//  SettingBaseView.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 8/7/24.
//

import UIKit

import SnapKit
import Then

class SettingBaseView: UIView {
    
    //MARK: - UI Properties
    
    let customBackButton = NavigationPopButton()
    private let borderView = UIView()
    let titleLabel = UILabel()
    let titleImageView = UIImageView()
    private let titleStackView = UIStackView()
    let settingBaseCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupHierarchy()
        setupStyle()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SettingBaseView {
    
    // MARK: - Layout
    
    private func setupStyle() {
        backgroundColor = .main(.main1)
        
        borderView.do {
            $0.backgroundColor = .grayscale(.gray100)
        }
        
        titleLabel.do {
            $0.font = .offroad(style: .iosTextTitle)
            $0.textColor = .main(.main2)
            $0.textAlignment = .center
        }
        
        titleStackView.do {
            $0.axis = .horizontal
            $0.spacing = 8
        }
        
        settingBaseCollectionView.do {
            let flowLayout = UICollectionViewFlowLayout()
            flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width - 20, height: 56)
            flowLayout.minimumLineSpacing = 12
            flowLayout.sectionInset = UIEdgeInsets(top: 26, left: .zero, bottom: 26, right: .zero)
            
            $0.collectionViewLayout = flowLayout
            $0.delaysContentTouches = false
            $0.register(SettingBaseCollectionViewCell.self, forCellWithReuseIdentifier: SettingBaseCollectionViewCell.className)
            
            $0.backgroundColor = .main(.main1)
            $0.showsVerticalScrollIndicator = false
        }
    }
    
    private func setupHierarchy() {
        addSubviews(
            customBackButton,
            titleStackView,
            borderView,
            settingBaseCollectionView
        )
        
        titleStackView.addArrangedSubviews(titleLabel, titleImageView)
    }
    
    private func setupLayout() {
        customBackButton.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(12)
            $0.leading.equalToSuperview().inset(12)
        }
        
        titleStackView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(98)
            $0.leading.equalToSuperview().inset(24)
        }
        
        borderView.snp.makeConstraints {
            $0.top.equalTo(titleStackView.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        settingBaseCollectionView.snp.makeConstraints {
            $0.top.equalTo(borderView.snp.bottom)
            $0.bottom.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(10)
        }
    }
}
