//
//  CourseQuestView.swift
//  Offroad-iOS
//
//  Created by  정지원 on 5/21/25.
//

import UIKit

import SnapKit
import Then

final class CourseQuestView: UIView {
    
    //MARK: - UI Properties
    
    private let customNavigationBar = UIView()
    let customBackButton = NavigationPopButton()
    
    let mapView = CourseQuestMapView()
    private let ddayContainerView = UIView()
    let ddayBadgeLabel = UILabel()
    private let calendarIconImageView = UIImageView()
    let deadlineDateLabel = UILabel()
    let listContainerView = UIScrollView()
    var listTopConstraint: Constraint? = nil
    
    let courseQuestPlaceCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        let layout = UICollectionViewFlowLayout()
        layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
        layout.itemSize = UICollectionViewFlowLayout.automaticSize
        layout.minimumLineSpacing = 19
        $0.collectionViewLayout = layout
        $0.backgroundColor = .clear
        $0.contentInset = .init(top: 17, left: 0, bottom: 125, right: 0)
        $0.register(CourseQuestPlaceCell.self, forCellWithReuseIdentifier: "CourseQuestPlaceCell")
    }
    
    private let rewardButton = ShrinkableButton()
    
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
    
    //MARK: - Private Func
    
    private func setupStyle() {
        backgroundColor = .main(.main1)
        
        customNavigationBar.do { view in
            view.backgroundColor = .main(.main1)
        }
        
        customBackButton.configureButtonTitle(titleString: "퀘스트 목록")
        
        mapView.do { view in
            view.clipsToBounds = true
        }
        
        calendarIconImageView.do { icon in
            icon.image = UIImage.icnPurpleCalendar
        }
        
        deadlineDateLabel.do { label in
            label.font = .offroad(style: .iosBoxMedi)
            label.textColor = .grayscale(.gray400)
            label.text = "퀘스트 마감일:__.__.__"
        }
        
        ddayBadgeLabel.do { label in
            label.font = .offroad(style: .iosQuestComplete)
            label.textColor = .sub(.sub480)
            label.text = "D-?"
        }
        
        listContainerView.do { view in
            view.backgroundColor = .main(.main1)
            view.showsVerticalScrollIndicator = false
        }
        
        courseQuestPlaceCollectionView.do { collectionView in
            collectionView.backgroundColor = .main(.main1)
            collectionView.delaysContentTouches = false
            collectionView.showsVerticalScrollIndicator = false
        }
        
        rewardButton.do { button in
            button.setTitle("보상: 포인트 1000원 적립", for: .normal)
            button.setTitleColor(.main(.main1), for: .normal)
            button.setTitleColor(.main(.main1), for: .highlighted)
            button.setTitleColor(.main(.main1), for: .disabled)
            button.configureTitleFontWhen(normal: .offroad(style: .iosText), disabled: .offroad(style: .iosTextBold))
            button.configureBackgroundColorWhen(normal: .main(.main2), disabled: .blackOpacity(.black15))
            button.roundCorners(cornerRadius: 5)
            button.isEnabled = false
        }
    }
    
    private func setupHierarchy() {
        addSubviews(
            customNavigationBar,
            customBackButton,
            mapView,
            listContainerView,
            rewardButton
        )
        listContainerView.addSubviews(ddayContainerView, courseQuestPlaceCollectionView)
        ddayContainerView.addSubviews(
            deadlineDateLabel,
            calendarIconImageView,
            ddayBadgeLabel
        )
    }
    
    private func setupLayout() {
        customNavigationBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(112)
        }
        
        customBackButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(60)
            make.leading.equalToSuperview().inset(14)
        }
        
        mapView.snp.makeConstraints { make in
            make.top.equalTo(customNavigationBar.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(259)
        }
        
        listContainerView.snp.makeConstraints { make in
            listTopConstraint = make.top.equalTo(mapView.snp.bottom).constraint
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
        }
        
        ddayContainerView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(22)
            $0.trailing.equalTo(listContainerView.frameLayoutGuide).inset(24)
            $0.height.equalTo(24)
        }
        
        deadlineDateLabel.snp.makeConstraints {
            $0.leading.centerY.equalToSuperview()
        }
        
        calendarIconImageView.snp.makeConstraints {
            $0.leading.equalTo(deadlineDateLabel.snp.trailing).offset(8)
            $0.verticalEdges.equalToSuperview()
            $0.size.equalTo(24)
        }
        
        ddayBadgeLabel.snp.makeConstraints {
            $0.leading.equalTo(calendarIconImageView.snp.trailing).offset(4)
            $0.centerY.trailing.equalToSuperview()
        }
        
        courseQuestPlaceCollectionView.snp.makeConstraints {
            $0.top.equalTo(ddayContainerView.snp.bottom)
            $0.bottom.equalToSuperview()
            $0.horizontalEdges.equalTo(listContainerView.frameLayoutGuide)
            $0.height.equalTo(357)
        }
        
        rewardButton.snp.makeConstraints {
            $0.top.equalTo(listContainerView.snp.bottom).offset(13.3)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(45.6)
            $0.height.equalTo(54)
        }
    }
    
    func configureMap(with places: [CourseQuestDetailPlaceDTO]) {
        mapView.configure(with: places)
    }
}
