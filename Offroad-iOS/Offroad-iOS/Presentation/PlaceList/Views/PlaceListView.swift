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
    class PlaceListScrollView: UIScrollView, ORBCenterLoadingStyle { }
    private(set) var scrollView = PlaceListScrollView()
    private let viewAllPlaces: UIView
    private let viewUnvisitedPlaces: UIView
    
    //MARK: - Life Cycle
    
    init(
        viewAllPlaces: UIView,
        viewUnvisitedPlaces: UIView
    ) {
        self.viewAllPlaces = viewAllPlaces
        self.viewUnvisitedPlaces = viewUnvisitedPlaces
        super.init(frame: .zero)
        
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
            configuration.image = .backBarButton
            configuration.baseForegroundColor = .main(.main2)
            configuration.imagePadding = 0
            configuration.contentInsets = .zero
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
        
        scrollView.do { scrollView in
            scrollView.isPagingEnabled = true
            scrollView.delaysContentTouches = false
            scrollView.showsHorizontalScrollIndicator = false
            scrollView.showsVerticalScrollIndicator = false
        }
    }
    
    private func setupHierarchy() {
        addSubviews(
            customNavigationBar,
            customBackButton,
            titleLabel,
            titleIcon,
            segmentedControl,
            separator,
            scrollView
        )
        
        scrollView.addSubviews(viewAllPlaces, viewUnvisitedPlaces)
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
        
        scrollView.snp.makeConstraints { make in
            make.top.equalTo(separator.snp.bottom)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
        
        viewAllPlaces.snp.makeConstraints { make in
            make.verticalEdges.equalTo(scrollView.frameLayoutGuide)
            make.leading.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(UIScreen.currentScreenSize.width)
        }
        
        viewUnvisitedPlaces.snp.makeConstraints { make in
            make.verticalEdges.equalTo(scrollView.frameLayoutGuide)
            make.leading.equalTo(viewAllPlaces.snp.trailing)
            make.trailing.equalTo(scrollView.contentLayoutGuide)
            make.width.equalTo(UIScreen.currentScreenSize.width)
        }
    }
    
}
