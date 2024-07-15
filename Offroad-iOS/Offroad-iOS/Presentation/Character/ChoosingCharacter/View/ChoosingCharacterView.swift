//
//  ChoosingCharacterView.swift
//  Offroad-iOS
//
//  Created by  정지원 on 7/10/24.
//

import UIKit

import SnapKit
import Then

final class ChoosingCharacterView: UIView {
    
    //MARK: - Properties
    
    private let choosingCharacterCell = ChoosingCharacterCell()
    
    let titleLabel = UILabel().then {
        $0.text = "동료 캐릭터 선택"
        $0.font = UIFont.offroad(style: .iosTextTitle)
        $0.textColor = UIColor.main(.main2)
    }
    
    private let divideLabelView = UIView().then {
        $0.backgroundColor = UIColor.sub(.sub4)
        $0.layer.opacity = 0.25
    }

    let choosingCharacterLabelView = UIView().then {
        $0.backgroundColor = UIColor.main(.main1)
    }
    
    let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: 284)
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.isPagingEnabled = true
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.backgroundColor = UIColor.sub(.sub)
        collectionView.isScrollEnabled = false
        return collectionView
    }()
    
    let leftButton = UIButton().then {
        $0.setImage(UIImage(resource: .imgLeftButton), for: .normal)
    }
    
    let rightButton = UIButton().then {
        $0.setImage(UIImage(resource: .imgRightButton), for: .normal)
    }
    
    
    let pageControl = UIPageControl().then {
        $0.currentPage = 0
        $0.pageIndicatorTintColor = UIColor.primary(.white).withAlphaComponent(0.4)
        $0.currentPageIndicatorTintColor = UIColor.primary(.white)
        $0.isUserInteractionEnabled = false
    }
    
    let nameLabel = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = UIColor.main(.main2)
        $0.font = UIFont.offroad(style: .iosTextTitle)
    }
    
    let discriptionLabel = UILabel().then {
        $0.textAlignment = .center
        $0.numberOfLines = 3
        $0.lineBreakMode = .byWordWrapping
        $0.textColor = UIColor.sub(.sub4)
        $0.font = UIFont.offroad(style: .iosTextRegular)
    }
    
    private let selectButton = UIButton().then {
        $0.setTitle("선택", for: .normal)
        $0.setBackgroundColor(.main(.main2), for: .normal)
        $0.titleLabel?.textAlignment = .center
        $0.titleLabel?.font = UIFont.offroad(style: .iosTextRegular)
        $0.setTitleColor(UIColor.main(.main1), for: .normal)
        $0.roundCorners(cornerRadius: 5)
    }
    
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

extension ChoosingCharacterView {
    
    // MARK: - Private Func
    
    private func setupHierarchy() {
        addSubviews(
            titleLabel,
            collectionView,
            pageControl,
            choosingCharacterLabelView,
            leftButton,
            rightButton
        )
        
        choosingCharacterLabelView.addSubview(nameLabel)
        choosingCharacterLabelView.addSubview(divideLabelView)
        choosingCharacterLabelView.addSubview(discriptionLabel)
        choosingCharacterLabelView.addSubview(selectButton)
    }
    
    private func setupStyle() {
        backgroundColor = UIColor.sub(.sub)
    }
    
    private func setupLayout() {
        
        titleLabel.snp.makeConstraints{ make in
            make.top.equalTo(safeAreaLayoutGuide).offset(70)
            make.centerX.equalToSuperview()
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(175)
            make.leading.trailing.equalToSuperview()
            make.height.equalTo(300)
        }
        
        leftButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(24)
            make.centerY.equalTo(collectionView)
        }
        
        rightButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(24)
            make.centerY.equalTo(collectionView)
        }
        
        pageControl.numberOfPages = 3
        
        pageControl.setIndicatorImage(UIImage(named: "img_current_indicator"), forPage: 0)
        pageControl.setIndicatorImage(UIImage(named: "img_current_indicator"), forPage: 1)
        pageControl.setIndicatorImage(UIImage(named: "img_current_indicator"), forPage: 2)
        
        pageControl.snp.makeConstraints { make in
            make.bottom.equalTo(choosingCharacterLabelView.snp.top).offset(-33)
            make.centerX.equalToSuperview()
        }
        
        choosingCharacterLabelView.snp.makeConstraints{ make in
            make.leading.trailing.bottom.equalToSuperview()
            make.height.equalTo(307)
        }
        
        nameLabel.snp.makeConstraints { make in
            make.top.equalTo(choosingCharacterLabelView.snp.top).offset(29)
            make.horizontalEdges.equalToSuperview().inset(50)
        }
        
        divideLabelView.snp.makeConstraints{ make in
            make.top.equalTo(nameLabel.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(50)
            make.height.equalTo(1)
        }
        
        discriptionLabel.snp.makeConstraints{ make in
            make.top.equalTo(divideLabelView.snp.bottom).offset(18)
            make.horizontalEdges.equalToSuperview().inset(50)
        }
        
        selectButton.snp.makeConstraints{ make in
            make.bottom.equalTo(safeAreaLayoutGuide).offset(-24)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(54)
            
        }
    }
    
    func setPageControlPageNumbers(pageNumber: Int) {
        pageControl.numberOfPages = pageNumber
    }
}


