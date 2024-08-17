//
//  CollectedTitlesView.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 8/5/24.
//

import UIKit

import SnapKit
import Then

final class CollectedTitlesView: UIView {

    //MARK: - UI Properties
    
    private let titleView = UIView()
    private let titleBorderView = UIView()
    private let titleLabel = UILabel()
    private let tagImageView = UIImageView(image: UIImage(resource: .imgTag))
    private let titleStackView = UIStackView()
    private let descriptionLabel = UILabel()
    private let checkCircleImageView = UIImageView(image: UIImage(resource: .iconCheckCircle))
    let collectedTitleCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
        
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

extension CollectedTitlesView {
    
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
            $0.text = "획득 칭호"
            $0.font = .offroad(style: .iosTextTitle)
            $0.textColor = .main(.main2)
            $0.textAlignment = .center
        }
        
        titleStackView.do {
            $0.axis = .horizontal
            $0.spacing = 8
        }
        
        descriptionLabel.do {
            $0.text = "퀘스트를 달성하고 보상으로 칭호를 얻어보아요!"
            $0.font = .offroad(style: .iosBoxMedi)
            $0.textColor = .sub(.sub2)
            $0.textAlignment = .center
        }
        
        collectedTitleCollectionView.do {
            let flowLayout = UICollectionViewFlowLayout()
            flowLayout.scrollDirection = .vertical
            $0.collectionViewLayout = flowLayout
            $0.register(CollectedTitleCollectionViewCell.self, forCellWithReuseIdentifier: CollectedTitleCollectionViewCell.className)

            $0.backgroundColor = .clear
            $0.showsVerticalScrollIndicator = false
            $0.contentInset = UIEdgeInsets(top: 20, left: 0, bottom: 20, right: 0)
        }
    }
    
    private func setupHierarchy() {
        addSubviews(
            titleView,
            titleBorderView,
            collectedTitleCollectionView
        )
        
        titleView.addSubviews(
            titleStackView,
            descriptionLabel,
            checkCircleImageView
        )
        
        titleStackView.addArrangedSubviews(titleLabel, tagImageView)
    }
    
    private func setupLayout() {
        titleView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(titleBorderView.snp.top)
        }
        
        titleBorderView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(183)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        titleStackView.snp.makeConstraints {
            $0.bottom.equalTo(checkCircleImageView.snp.top).offset(-15)
            $0.leading.equalToSuperview().inset(24)
        }
        
        checkCircleImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(25)
        }
        
        descriptionLabel.snp.makeConstraints {
            $0.leading.equalTo(checkCircleImageView.snp.trailing).offset(6)
            $0.centerY.equalTo(checkCircleImageView.snp.centerY)
        }
        
        collectedTitleCollectionView.snp.makeConstraints {
            $0.top.equalTo(titleBorderView.snp.bottom)
            $0.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
}
