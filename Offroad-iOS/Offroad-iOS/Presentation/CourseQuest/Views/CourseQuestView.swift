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
    
    let mapView = UIView()
    let listContainerView = UIView()
    
    let courseQuestPlaceCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 48, height: 97)
        layout.minimumLineSpacing = 14
        $0.collectionViewLayout = layout
        $0.backgroundColor = .clear
        $0.contentInset = .init(top: 16, left: 0, bottom: 16, right: 0)
        $0.register(CourseQuestPlaceCell.self, forCellWithReuseIdentifier: "CourseQuestPlaceCell")
    }
    
    private let rewardButton = ShrinkableButton()
    
    var listTopConstraint: Constraint? = nil
    
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
        backgroundColor = .primary(.listBg)
        
        customNavigationBar.do { view in
            view.backgroundColor = .main(.main1)
        }
        
        customBackButton.configureButtonTitle(titleString: "퀘스트 목록")
        
        listContainerView.do { collectionView in
            collectionView.backgroundColor = .primary(.listBg)
            collectionView.clipsToBounds = true
        }
        
        courseQuestPlaceCollectionView.do { collectionView in
            collectionView.backgroundColor = .primary(.listBg)
            collectionView.delaysContentTouches = false
        }
        
        rewardButton.do { button in
            button.setTitle("보상: 포인트 1000원 적립", for: .normal)
            button.setTitleColor(.main(.main1), for: .normal)
            button.setTitleColor(.main(.main1), for: .highlighted)
            button.setTitleColor(.main(.main1), for: .disabled)
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
        listContainerView.addSubview(courseQuestPlaceCollectionView)
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
            make.horizontalEdges.equalToSuperview()
            self.listTopConstraint = make.top.equalTo(mapView.snp.bottom).constraint
        }
        
        courseQuestPlaceCollectionView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        rewardButton.snp.makeConstraints {
            $0.left.right.equalToSuperview().inset(12)
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(12)
            $0.height.equalTo(44)
        }
    }
}
