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

    let customNavigationBar = UIView()
    let customBackButton = UIButton()
    let titleLabel = UILabel()
    let titleIcon = UIImageView()
    let ongoingQuestLabel = UILabel()
    let ongoingQuestToggle = UISwitch()
    let separator = UIView()

    var questListCollectionView: UICollectionView!

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
        
        ongoingQuestLabel.do { label in
            label.font = .offroad(style: .iosTextContents)
            label.text = "진행 중"
            label.textColor = .grayscale(.gray400)
        }
        
        ongoingQuestToggle.do {
            $0.isOn = false
            $0.tintColor = .sub(.sub)
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

        questListCollectionView = UICollectionView(frame: .zero, collectionViewLayout: layoutForPlaceNeverVisited)
        questListCollectionView.backgroundColor = UIColor(hexCode: "F6EEDF")
    }

    private func setupHierarchy() {
        addSubviews(
            customNavigationBar,
            customBackButton,
            titleLabel,
            ongoingQuestLabel,
            ongoingQuestToggle,
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
        
        ongoingQuestLabel.snp.makeConstraints { make in
            make.centerY.equalTo(titleLabel)
            make.trailing.equalTo(ongoingQuestToggle.snp.leading).offset(-6)
        }
        
        ongoingQuestToggle.snp.makeConstraints { make in
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
