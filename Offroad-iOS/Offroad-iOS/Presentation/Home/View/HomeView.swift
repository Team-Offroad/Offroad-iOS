//
//  HomeView.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 7/9/24.
//

import UIKit

import Kingfisher
import SnapKit
import Then

final class HomeView: UIView {
    
    //MARK: - Properties
    
    typealias ChangeTitleButtonAction = () -> Void

    private var changeTitleButtonAction: ChangeTitleButtonAction?

    //MARK: - UI Properties
    
    private let nicknameLabel = UILabel()
    private let characterNameView = UIView()
    private let characterNameLabel = UILabel()
    private let offroadStampImageView = UIImageView(image: UIImage(resource: .imgOffroadStamp))
    private let downloadButton = UIButton()
    private let shareButton = UIButton()
    private let changeCharacterButton = UIButton()
    private let buttonStackView = UIStackView()
    private let characterImageView = UIImageView(image: UIImage(resource: .imgCharacter))
    private let titleView = UIView()
    private let titleLabel = UILabel()
    private let changeTitleButton = UIButton()
    private var recentQuestView = CustomQuestView()
    private var almostDoneQuestView = CustomQuestView()
    private let questStackView = UIStackView()
    private let recentQuestProgressView = CustomRecentProgressView()
    private let recentQuestProgressLabel = UILabel()
    private let almostDoneQuestProgressView = CustomAlmostDoneProgressView()
    private let almostDoneQuestProgressLabel = UILabel()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupHierarchy()
        setupStyle()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension HomeView {
    
    // MARK: - Layout
    
    private func setupStyle() {
        backgroundColor = .main(.main1)
        
        nicknameLabel.do {
            $0.font = .offroad(style: .iosSubtitleReg)
            $0.textAlignment = .center
            $0.textColor = .main(.main2)
        }
        
        characterNameView.do {
            $0.backgroundColor = .home(.homeCharacterName)
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.home(.homeNicknameStroke).cgColor
            $0.roundCorners(cornerRadius: 7)
        }
        
        characterNameLabel.do {
            $0.font = .offroad(style: .iosSubtitle2Semibold)
            $0.textAlignment = .center
            $0.textColor = .primary(.white)
        }
        
        downloadButton.do {
            $0.setImage(.btnDownload, for: .normal)
        }
        
        shareButton.do {
            $0.setImage(.btnShare, for: .normal)
        }
        
        changeCharacterButton.do {
            $0.setImage(.btnChangeCharacter, for: .normal)
        }
        
        [downloadButton, shareButton, changeCharacterButton].forEach { button in
            button.layer.shadowColor = UIColor.black.cgColor
            button.layer.shadowOffset = CGSize(width: 0, height: 1)
            button.layer.shadowOpacity = 0.1
            button.layer.shadowRadius = 4
        }
        
        buttonStackView.do {
            $0.axis = .vertical
            $0.spacing = 9
        }
        
        titleView.do {
            $0.backgroundColor = .sub(.sub)
            $0.roundCorners(cornerRadius: 10)
        }
        
        titleLabel.do {
            $0.font = .offroad(style: .iosSubtitle2Semibold)
            $0.textAlignment = .center
            $0.textColor = .primary(.white)
        }
        
        changeTitleButton.do {
            $0.backgroundColor = .main(.main3)
            $0.setImage(.iconChangeTitle, for: .normal)
            $0.roundCorners(cornerRadius: 9)
        }
        
        recentQuestView.configureCustomView(mainColor: .home(.homeContents1), questString: "최근 진행한 퀘스트", textColor: .main(.main1), image: .imgCompass)
        almostDoneQuestView.configureCustomView(mainColor: .home(.homeContents2), questString: "완료 임박 퀘스트", textColor: .sub(.sub4), image: .imgFire)
        
        questStackView.do {
            $0.axis = .horizontal
            $0.spacing = 13
            $0.distribution = .fillEqually
        }
        
        recentQuestProgressLabel.do {
            $0.textColor = .main(.main1)
            $0.textAlignment = .center
            $0.font = .offroad(style: .bothRecentNum)
        }
        
        almostDoneQuestProgressLabel.do {
            $0.textColor = .blackOpacity(.black25)
            $0.textAlignment = .center
            $0.font = .offroad(style: .bothUpcomingSmallNum)
        }
    }
    
    private func setupHierarchy() {
        addSubviews(
            nicknameLabel,
            characterNameView,
            offroadStampImageView,
            buttonStackView,
            characterImageView,
            titleView,
            questStackView
        )
        
        characterNameView.addSubview(characterNameLabel)
        buttonStackView.addArrangedSubviews(
            downloadButton,
            shareButton,
            changeCharacterButton
        )
        titleView.addSubviews(titleLabel, changeTitleButton)
        questStackView.addArrangedSubviews(recentQuestView, almostDoneQuestView)
        recentQuestView.addSubviews(recentQuestProgressView, recentQuestProgressLabel)
        almostDoneQuestView.addSubviews(almostDoneQuestProgressView, almostDoneQuestProgressLabel)
    }
    
    private func setupLayout() {
        nicknameLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(26)
            $0.leading.equalToSuperview().inset(24)
        }
        
        characterNameView.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(17)
            $0.leading.equalToSuperview().inset(24)
            $0.height.equalTo(32)
        }
        
        characterNameLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(17)
        }
        
        offroadStampImageView.snp.makeConstraints {
            $0.top.trailing.equalTo(safeAreaLayoutGuide)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(characterNameView.snp.top)
            $0.trailing.equalToSuperview().inset(24)
        }
        
        characterImageView.snp.makeConstraints {
            $0.bottom.equalTo(titleView.snp.top).offset(-25)
            $0.centerX.equalToSuperview()
        }
        
        titleView.snp.makeConstraints {
            $0.bottom.equalTo(questStackView.snp.top).offset(-13)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(43)
        }
        
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        changeTitleButton.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.width.height.equalTo(30)
            $0.trailing.equalToSuperview().inset(11)
        }
        
        questStackView.snp.makeConstraints {
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(40)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(195)
        }
        
        recentQuestProgressView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.width.equalTo(82)
        }
        
        recentQuestProgressLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        almostDoneQuestProgressView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview().inset(15)
            $0.bottom.equalToSuperview().inset(57)
            $0.height.equalTo(9)
        }
        
        almostDoneQuestProgressLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(58)
            $0.centerX.equalToSuperview()
        }
    }
    
    //MARK: - @Objc Method
    
    @objc private func changeTitleButtonTapped() {
        changeTitleButtonAction?()
    }
    
    //MARK: - Func
    
    func changeMyTitleLabelText(text: String) {
        titleLabel.text = text
    }
    
    func updateAdventureInfo(nickname: String, characterImgUrl: String, characterName: String, emblemName: String) {
        nicknameLabel.text = "모험가 \(nickname)님"
        nicknameLabel.highlightText(targetText: nickname, font: .offroad(style: .iosSubtitle2Bold))
        
        let url = URL(string: characterImgUrl)
        characterImageView.kf.setImage(with: url)
        
        characterNameLabel.text = characterName
        
        titleLabel.text = emblemName
    }
    
    func updateQuestInfo(recentQuestName: String, recentProgress: Int, recentCompleteCondition: Int, almostQuestName: String, almostprogress: Int, almostCompleteCondition: Int) {
        recentQuestView.setupDetailString(detailString: recentQuestName)
        almostDoneQuestView.setupDetailString(detailString: almostQuestName)
        
        recentQuestProgressLabel.text = "\(recentProgress)/\(recentCompleteCondition)"
        almostDoneQuestProgressLabel.text = "\(almostprogress) / \(almostCompleteCondition)"
        almostDoneQuestProgressLabel.highlightText(targetText: "\(almostprogress)", font: .offroad(style: .bothUpcomingBigNum), color: .sub(.sub4))

        
        let recentProgressValue = CGFloat(recentProgress)/CGFloat(recentCompleteCondition)
        let almostProgressValue = CGFloat(almostprogress)/CGFloat(almostCompleteCondition)
        
        recentQuestProgressView.setProgressView(progressValue: recentProgressValue)
        almostDoneQuestProgressView.setProgressView(progressValue: almostProgressValue)
    }
    
    //MARK: - targetView Method
    
    func setupChangeTitleButton(action: @escaping ChangeTitleButtonAction) {
        changeTitleButtonAction = action
        changeTitleButton.addTarget(self, action: #selector(changeTitleButtonTapped), for: .touchUpInside)
    }
}
