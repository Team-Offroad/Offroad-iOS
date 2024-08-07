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
    
    private let titleView = UIView()
    private let titleBorderView = UIView()
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
        backgroundColor = .primary(.listBg)
        
        titleView.do {
            $0.backgroundColor = .main(.main1)
        }
        
        titleBorderView.do {
            $0.backgroundColor = .grayscale(.gray100)
        }
        
        titleLabel.do {
            $0.text = "설정"
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
            flowLayout.itemSize = CGSize(width: UIScreen.main.bounds.width - 48, height: 44)
            flowLayout.minimumLineSpacing = 16
            flowLayout.sectionInset = UIEdgeInsets(top: 18, left: 24, bottom: 18, right: 24)
            $0.collectionViewLayout = flowLayout
            $0.register(SettingBaseCollectionViewCell.self, forCellWithReuseIdentifier: SettingBaseCollectionViewCell.className)
            
            $0.backgroundColor = .main(.main1)
        }
    }
    
    private func setupHierarchy() {
        addSubviews(
            titleView,
            titleBorderView,
            settingBaseCollectionView
        )
        
        titleView.addSubview(titleStackView)
        titleStackView.addArrangedSubviews(titleLabel, titleImageView)
    }
    
    private func setupLayout() {
        titleView.snp.makeConstraints {
            $0.top.horizontalEdges.equalTo(safeAreaLayoutGuide)
            $0.height.equalTo(92)
        }
        
        titleBorderView.snp.makeConstraints {
            $0.top.equalTo(titleView.snp.bottom)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        titleStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(42)
            $0.leading.equalToSuperview().inset(24)
        }
        
        settingBaseCollectionView.snp.makeConstraints {
            $0.top.equalTo(titleBorderView.snp.bottom).offset(17)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(440)
        }
    }
}
