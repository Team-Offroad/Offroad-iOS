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
    
    //MARK: - Properties
    
    private var layoutMaker: UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = .init(top: 20, left: 24, bottom: 0, right: 24)
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 100
        layout.estimatedItemSize.width = UIScreen.current.bounds.width - 32
        return layout
    }

    //MARK: - UI Properties

    private let customNavigationBar = UIView()
    private let titleLabel = UILabel()
    private let titleIcon = UIImageView()
    private let ongoingQuestLabel = UILabel()
    private let separator = UIView()
    
    let customBackButton = UIButton()
    let ongoingQuestToggle = UISwitch()
    
    lazy var questListCollectionView: UICollectionView = UICollectionView(frame: .zero, collectionViewLayout: layoutMaker)
    var activityIndicatorView = UIActivityIndicatorView(style: .large)

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

        customBackButton.do { button in
            
            let transformer = UIConfigurationTextAttributesTransformer { incoming in
                var outgoing = incoming
                outgoing.font = UIFont.offroad(style: .iosTextAuto)
                outgoing.foregroundColor = UIColor.main(.main2)
                return outgoing
            }
            
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
            label.text = "퀘스트 목록"
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
            // (이슈 해결 후 주석 삭제 예정)
            // $0.tintColor = .sub(.sub)
            // UISwitch 의 tintColor에 대해 공부하기! (onSwitch와의 차이점?)
            $0.onTintColor = .sub(.sub)
        }
        
        separator.do { view in
            view.backgroundColor = .grayscale(.gray100)
        }
        
        questListCollectionView.do { collectionView in
            collectionView.backgroundColor = .primary(.listBg)
            collectionView.refreshControl = UIRefreshControl()
            collectionView.refreshControl?.tintColor = .sub(.sub)
        }
        
        activityIndicatorView.do { indicatorView in
            indicatorView.color = .sub(.sub2)
            indicatorView.startAnimating()
        }
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
        questListCollectionView.addSubview(activityIndicatorView)
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
        
        activityIndicatorView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }

}
