//
//  DiaryGuideView.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 3/4/25.
//

import UIKit

import SnapKit
import Then

final class DiaryGuideView: UIView {
    
    //MARK: - UI Properties
    
    let closeButton = UIButton()
    let guideCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    let pageControl = UIPageControl()
    let nextButton = ShrinkableButton()
    
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

extension DiaryGuideView {
    
    // MARK: - Layout
    
    private func setupStyle() {
        backgroundColor = .blackOpacity(.black75)
        
        closeButton.do {
            $0.setImage(.iconCloseWhite, for: .normal)
        }
        
        guideCollectionView.do {
            let flowLayout = UICollectionViewFlowLayout()
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 0
            flowLayout.minimumInteritemSpacing = 0
            
            $0.collectionViewLayout = flowLayout
            $0.isPagingEnabled = true
            $0.showsHorizontalScrollIndicator = false
            $0.backgroundColor = .clear
            
            $0.register(GuideCollectionViewCell.self, forCellWithReuseIdentifier: GuideCollectionViewCell.className)
        }
        
        pageControl.do {
            $0.currentPage = 0
            $0.pageIndicatorTintColor = UIColor.primary(.white).withAlphaComponent(0.4)
            $0.currentPageIndicatorTintColor = UIColor.primary(.white)
            $0.isUserInteractionEnabled = false
            $0.numberOfPages = 2
            
            for i in 0..<2 {
                $0.setIndicatorImage(UIImage(resource: .imgCurrentIndicator), forPage: i)
            }
        }
        
        nextButton.do {
            $0.setTitle("다음", for: .normal)
            $0.setTitleColor(.main(.main1), for: .normal)
            $0.titleLabel?.font = .offroad(style: .iosText)
            $0.titleLabel?.setLineHeight(percentage: 150)
            $0.backgroundColor = .sub(.sub)
            $0.roundCorners(cornerRadius: 5)
        }
    }
    
    private func setupHierarchy() {
        addSubviews(
            closeButton,
            guideCollectionView,
            pageControl,
            nextButton
        )
    }
    
    private func setupLayout() {
        closeButton.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(4)
            $0.trailing.equalToSuperview().inset(14)
            $0.size.equalTo(44)
        }
        
        guideCollectionView.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(safeAreaLayoutGuide).inset(100)
            $0.top.lessThanOrEqualTo(safeAreaLayoutGuide).inset(150)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(418).priority(.low)
        }
        
        pageControl.snp.makeConstraints {
            $0.top.equalTo(guideCollectionView.snp.bottom).offset(54)
            $0.centerX.equalToSuperview()
            $0.bottom.equalTo(nextButton.snp.top).offset(-80)
        }
        
        nextButton.snp.makeConstraints {
            $0.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide).inset(24)
            $0.height.equalTo(54)
        }
    }
}
