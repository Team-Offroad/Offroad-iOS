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
    
    let customNavigationBar = UIView()
    let customBackButton = UIButton()
    let titleLabel = UILabel()
    let titleIcon = UIImageView()
    let segmentedControl = OFRSegmentedControl(titles: ["안 가본 곳", "전체"])
    let separator = UIView()
    let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    
    var placeNeverVisitedListCollectionView: UICollectionView!
    var allPlaceListCollectionView: UICollectionView!
    var activityIndicator = UIActivityIndicatorView(style: .large)
    
    private var layoutMaker: UICollectionViewFlowLayout {
        let collectionViewHorizontalInset: CGFloat = 24
        let collectionViewVerticalInset: CGFloat = 20
        let itemWidth = floor(UIScreen.current.bounds.width - collectionViewHorizontalInset * 2)
        
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = .init(
            top: collectionViewVerticalInset,
            left: collectionViewHorizontalInset,
            bottom: collectionViewVerticalInset,
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
        
        placeNeverVisitedListCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layoutMaker)
        placeNeverVisitedListCollectionView.backgroundColor = .primary(.listBg)
        placeNeverVisitedListCollectionView.indicatorStyle = .black
        
        allPlaceListCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layoutMaker)
        allPlaceListCollectionView.backgroundColor = .primary(.listBg)
        allPlaceListCollectionView.indicatorStyle = .black
        
        activityIndicator.do { indicator in
            indicator.color = .sub(.sub)
            indicator.isHidden = false
            indicator.startAnimating()
        }
    }
    
    private func setupHierarchy() {
        addSubviews(
            customNavigationBar,
            customBackButton,
            titleLabel,
            segmentedControl,
            separator,
            pageViewController.view,
            activityIndicator
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
        
        activityIndicator.snp.makeConstraints { make in
            make.center.equalTo(pageViewController.view)
        }
    }
    
}
