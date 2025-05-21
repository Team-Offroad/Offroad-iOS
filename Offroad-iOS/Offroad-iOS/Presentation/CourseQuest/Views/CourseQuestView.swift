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
    
    let courseQuestPlaceCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout()).then {
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: UIScreen.main.bounds.width - 48, height: 97)
        layout.minimumLineSpacing = 14
        $0.collectionViewLayout = layout
        $0.backgroundColor = .clear
        $0.contentInset = .init(top: 16, left: 0, bottom: 16, right: 0)
        $0.register(CourseQuestPlaceCell.self, forCellWithReuseIdentifier: "CourseQuestPlaceCell")
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
    
    //MARK: - Private Func
    
    private func setupStyle() {
        backgroundColor = .primary(.listBg)
        
        customNavigationBar.do { view in
            view.backgroundColor = .main(.main1)
        }
        
        customBackButton.configureButtonTitle(titleString: "퀘스트 목록")
        
        courseQuestPlaceCollectionView.do { collectionView in
            collectionView.backgroundColor = .primary(.listBg)
            collectionView.delaysContentTouches = false
        }
    }
    
    private func setupHierarchy() {
        addSubviews(
            customNavigationBar,
            customBackButton,
            courseQuestPlaceCollectionView
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
        
        courseQuestPlaceCollectionView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(customNavigationBar.snp.bottom).offset(20)
            make.bottom.equalToSuperview()
        }
    }
}
