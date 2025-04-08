//
//  QuestListView.swift
//  Offroad-iOS
//
//  Created by 김민성 on 8/10/24.
//

import UIKit

import Then
import SnapKit

class QuestListView: UIView {
    
    //MARK: - UI Properties

    private let customNavigationBar = UIView()
    private let titleLabel = UILabel()
    private let titleIcon = UIImageView(image: UIImage(resource: .imgQuest))
    private let ongoingQuestLabel = UILabel()
    private let separator = UIView()
    
    let customBackButton = NavigationPopButton()
    let ongoingQuestSwitch = UISwitch()
    
    let questListCollectionView = QuestListCollectionView()
    

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

extension QuestListView {

    //MARK: - Private Func

    private func setupStyle() {
        backgroundColor = .primary(.listBg)
        
        customNavigationBar.do { view in
            view.backgroundColor = .main(.main1)
        }

        customBackButton.configureButtonTitle(titleString: "탐험")

        titleLabel.do { label in
            label.text = "퀘스트 목록"
            label.font = .offroad(style: .iosTextTitle)
            label.textColor = .main(.main2)
        }
        
        ongoingQuestLabel.do { label in
            label.font = .offroad(style: .iosTextContents)
            label.text = "진행 중"
            label.textColor = .grayscale(.gray400)
        }
        
        ongoingQuestSwitch.do {
            $0.isOn = true
            $0.onTintColor = .sub(.sub)
        }
        
        separator.do { view in
            view.backgroundColor = .grayscale(.gray100)
        }
        
        questListCollectionView.do { collectionView in
            collectionView.backgroundColor = .primary(.listBg)
            collectionView.delaysContentTouches = false
        }
    }

    private func setupHierarchy() {
        addSubviews(
            customNavigationBar,
            customBackButton,
            titleLabel,
            titleIcon,
            ongoingQuestLabel,
            ongoingQuestSwitch,
            separator,
            questListCollectionView
        )
    }

    private func setupLayout() {
        customNavigationBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(titleLabel.snp.bottom).offset(28)
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
        
        ongoingQuestLabel.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.trailing.equalTo(ongoingQuestSwitch.snp.leading).offset(-6)
        }
        
        ongoingQuestSwitch.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.trailing.equalToSuperview().inset(24)
        }
        
        separator.snp.makeConstraints { make in
            make.top.equalTo(customNavigationBar.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(1)
        }

        questListCollectionView.snp.makeConstraints { make in
            make.top.equalTo(separator.snp.bottom)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.bottom.equalToSuperview()
        }
    }

}
