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
    let customSegmentedControl = CustomSegmentedControl()
    let separator = UIView()
    
    var placeNeverVisitedListCollectionView: UICollectionView!
    var allPlaceListCollectionView: UICollectionView!
    
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
        // 추후 ColorLiteral로 변경 요망
        backgroundColor = UIColor(hexCode: "F6EEDF")
        
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
        
        customSegmentedControl.do { segmentedControl in
            segmentedControl.addSegments(titles: ["안 가본 곳", "전체"])
        }
        
        separator.do { view in
            view.backgroundColor = .grayscale(.gray100)
        }
        
        let layoutForPlaceNeverVisited = UICollectionViewFlowLayout()
        layoutForPlaceNeverVisited.scrollDirection = .vertical
        layoutForPlaceNeverVisited.sectionInset = .init(top: 20, left: 24, bottom: 0, right: 24)
        layoutForPlaceNeverVisited.minimumLineSpacing = 16
        layoutForPlaceNeverVisited.minimumInteritemSpacing = 100
        layoutForPlaceNeverVisited.estimatedItemSize.width = UIScreen.current.bounds.width - 32
        
        let layoutForAllPlace = UICollectionViewFlowLayout()
        layoutForAllPlace.scrollDirection = .vertical
        layoutForAllPlace.sectionInset = .init(top: 20, left: 24, bottom: 0, right: 24)
        layoutForAllPlace.minimumLineSpacing = 16
        layoutForAllPlace.minimumInteritemSpacing = 100
        layoutForAllPlace.estimatedItemSize.width = UIScreen.current.bounds.width - 32
        
        placeNeverVisitedListCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layoutForPlaceNeverVisited)
        placeNeverVisitedListCollectionView.backgroundColor = UIColor(hexCode: "F6EEDF")
        
        allPlaceListCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layoutForAllPlace)
        allPlaceListCollectionView.backgroundColor = UIColor(hexCode: "F6EEDF")
        
        allPlaceListCollectionView.isHidden = true
    }
    
    private func setupHierarchy() {
        addSubviews(
            customNavigationBar,
            customBackButton,
            titleLabel,
            customSegmentedControl,
            separator,
            placeNeverVisitedListCollectionView,
            allPlaceListCollectionView
        )
    }
    
    private func setupLayout() {
        customNavigationBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(customSegmentedControl.snp.bottom)
        }
        
        customBackButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(60)
            make.leading.equalToSuperview().inset(14)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(customBackButton.snp.bottom).offset(39)
            make.leading.equalToSuperview().inset(23)
        }
        
        customSegmentedControl.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(15)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(24.5)
            make.height.equalTo(46)
        }
        
        separator.snp.makeConstraints { make in
            make.top.equalTo(customSegmentedControl.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(1)
        }
        
        placeNeverVisitedListCollectionView.snp.makeConstraints { make in
            make.top.equalTo(separator.snp.bottom)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
        
        allPlaceListCollectionView.snp.makeConstraints { make in
            make.top.equalTo(separator.snp.bottom)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
    }
    
}