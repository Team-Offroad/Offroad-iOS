//
//  PlaceListView.swift
//  Offroad-iOS
//
//  Created by 김민성 on 8/3/24.
//

import UIKit

import Then
import SnapKit

class PlaceListView: UIView {
    
    //MARK: - UI Properties
    
    private let customNavigationBar = UIView()
    let customBackButton = UIButton()
    private let titleLabel = UILabel()
    private let titleIcon = UIImageView(image: .imgQuest)
    let segmentedControl = ORBSegmentedControl(titles: ["안 가본 곳", "전체"])
    private let separator = UIView()
    let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    
    var unvisitedPlacesCollectionView: ScrollLoadingCollectionView!
    var allPlacesCollectionView: ScrollLoadingCollectionView!
    
    private var layoutMaker: UICollectionViewFlowLayout {
        let collectionViewHorizontalInset: CGFloat = 24
        let collectionViewVerticalInset: CGFloat = 20
        let itemWidth = floor(UIScreen.current.bounds.width - collectionViewHorizontalInset * 2)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = .init(
            top: collectionViewVerticalInset,
            left: collectionViewHorizontalInset,
            bottom: 40,
            right: collectionViewHorizontalInset
        )
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 100
        layout.estimatedItemSize = CGSize(width: itemWidth, height: 125)
        return layout
    }
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PlaceListView {
    
    //MARK: - Private Func
    
    private func setupStyle() {
        backgroundColor = .primary(.listBg)
        
        customNavigationBar.do { view in
            view.backgroundColor = .main(.main1)
        }
        
        let transformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            outgoing.font = UIFont.offroad(style: .iosTextAuto)
            outgoing.foregroundColor = UIColor.main(.main2)
            return outgoing
        }
        
        customBackButton.do { button in
            var configuration = UIButton.Configuration.plain()
            configuration.titleTextAttributesTransformer = transformer
            // 지금은 SFSymbol 사용, 추후 변경 예정
            configuration.image = .init(systemName: "chevron.left")?.withTintColor(.main(.main2))
            configuration.baseForegroundColor = .main(.main2)
            configuration.imagePadding = 10
            configuration.title = "탐험"
            
            button.configuration = configuration
        }
        
        titleLabel.do { label in
            label.text = "장소 목록"
            label.font = .offroad(style: .iosTextTitle)
            label.textColor = .main(.main2)
        }
        
        separator.do { view in
            view.backgroundColor = .grayscale(.gray100)
        }
        
        unvisitedPlacesCollectionView = ScrollLoadingCollectionView(frame: .zero, collectionViewLayout: layoutMaker)
        unvisitedPlacesCollectionView.backgroundColor = .primary(.listBg)
        unvisitedPlacesCollectionView.indicatorStyle = .black
        unvisitedPlacesCollectionView.setEmptyStateMessage(EmptyCaseMessage.unvisitedPlaceList)
        unvisitedPlacesCollectionView.contentInsetAdjustmentBehavior = .never
        
        allPlacesCollectionView = ScrollLoadingCollectionView(frame: .zero, collectionViewLayout: layoutMaker)
        allPlacesCollectionView.backgroundColor = .primary(.listBg)
        allPlacesCollectionView.indicatorStyle = .black
        allPlacesCollectionView.setEmptyStateMessage(EmptyCaseMessage.placeList)
        allPlacesCollectionView.contentInsetAdjustmentBehavior = .never
    }
    
    private func setupHierarchy() {
        addSubviews(
            customNavigationBar,
            customBackButton,
            titleLabel,
            titleIcon,
            segmentedControl,
            separator,
            pageViewController.view
        )
    }
    
    private func setupLayout() {
        customNavigationBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(segmentedControl.snp.bottom)
        }
        
        customBackButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(60)
            make.leading.equalToSuperview().inset(14)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(customBackButton.snp.bottom).offset(39)
            make.leading.equalToSuperview().inset(23)
        }
        
        titleIcon.snp.makeConstraints{ make in
            make.leading.equalTo(titleLabel.snp.trailing).offset(8)
            make.centerY.equalTo(titleLabel.snp.centerY)
            make.size.equalTo(24)
        }
        
        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(24.5)
            make.height.equalTo(46)
        }
        
        separator.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(1)
        }
        
        pageViewController.view.snp.makeConstraints { make in
            make.top.equalTo(separator.snp.bottom)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
    }
    
}
