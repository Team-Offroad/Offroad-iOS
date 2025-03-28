//
//  HomeView.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 7/9/24.
//

import UIKit

import Kingfisher
import SnapKit
import SVGKit
import Then
import Lottie

final class HomeView: UIView {
    
    //MARK: - UI Properties
    
    private let nicknameLabel = UILabel()
    private let characterNameView = UIView()
    private let characterNameLabel = UILabel()
    private let backgroundImageView = UIImageView(image: UIImage(resource: .imgHomeBackground))
    let chatButton = UIButton()
    let chatUnreadDotView = UIView()
    let shareButton = UIButton()
    let changeCharacterButton = UIButton()
    let recommendButton = UIButton()
    let diaryButton = UIButton()
    let diaryUnreadDotView = UIView()
    private let buttonStackView = UIStackView()
    private let characterMotionView = LottieAnimationView()
    private let titleView = UIView()
    private let titleLabel = UILabel()
    let changeTitleButton = UIButton()
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
        backgroundColor = .darkGray
        
        nicknameLabel.do {
            $0.font = .offroad(style: .bothSubtitle3)
            $0.textAlignment = .center
            $0.textColor = .main(.main1)
        }
        
        characterNameView.do {
            $0.backgroundColor = .sub(.sub55)
            $0.layer.borderWidth = 1
            $0.layer.borderColor = UIColor.sub(.sub).cgColor
            $0.roundCorners(cornerRadius: 17)
        }
        
        characterNameLabel.do {
            $0.font = .offroad(style: .iosSubtitle2Semibold)
            $0.textAlignment = .center
            $0.textColor = .primary(.white)
        }
        
        chatButton.do {
            $0.setImage(.btnChat, for: .normal)
        }
        
        chatUnreadDotView.do {
            $0.backgroundColor = .primary(.errorNew)
            $0.roundCorners(cornerRadius: 4)
            $0.isHidden = true
        }
        
        shareButton.do {
            $0.setImage(.btnShare, for: .normal)
        }
        
        changeCharacterButton.do {
            $0.setImage(.btnChangeCharacter, for: .normal)
        }

        recommendButton.do {
            $0.setImage(.btnRecommend, for: .normal)
        }
        
        diaryButton.do {
            $0.setImage(.btnDiaryHome, for: .normal)
        }
        
        diaryUnreadDotView.do {
            $0.backgroundColor = .primary(.errorNew)
            $0.roundCorners(cornerRadius: 4)
            $0.isHidden = true
        }
        
        [chatButton, recommendButton, changeCharacterButton, diaryButton].forEach { button in
            button.layer.shadowColor = UIColor.black.cgColor
            button.layer.shadowOffset = CGSize(width: 0, height: 1)
            button.layer.shadowOpacity = 0.1
            button.layer.shadowRadius = 4
        }
        
        buttonStackView.do {
            $0.axis = .vertical
            $0.spacing = 9
        }
        
        characterMotionView.do {
            $0.contentMode = .scaleAspectFit
            $0.loopMode = .repeat(60)
        }
        
        titleView.do {
            $0.backgroundColor = .whiteOpacity(.white25)
            $0.layer.borderColor = UIColor.whiteOpacity(.white25).cgColor
            $0.layer.borderWidth = 1
            $0.roundCorners(cornerRadius: 10)
        }
        
        titleLabel.do {
            $0.font = .offroad(style: .iosSubtitle2Semibold)
            $0.textAlignment = .center
            $0.textColor = .primary(.white)
        }
        
        changeTitleButton.do {
            $0.backgroundColor = .main(.main3)
            $0.setImage(.btnChangeTitle, for: .normal)
            $0.roundCorners(cornerRadius: 9)
        }
        
        recentQuestView.configureCustomView(mainColor: .home(.homeContents1), questString: "최근 진행한 퀘스트", textColor: .main(.main1), image: .imgCompass)
        almostDoneQuestView.configureCustomView(mainColor: .home(.homeContents2), questString: "완료 임박 퀘스트", textColor: .main(.main1), image: .imgFire)
        
        questStackView.do {
            $0.axis = .horizontal
            $0.spacing = 13
            $0.distribution = .fillEqually
        }
        
        recentQuestProgressLabel.do {
            $0.textColor = .whiteOpacity(.white25)
            $0.textAlignment = .center
            $0.font = .offroad(style: .bothRecentNumRegular)
            $0.adjustsFontSizeToFitWidth = true
            $0.minimumScaleFactor = 0.5
        }
        
        almostDoneQuestProgressLabel.do {
            $0.textColor = .whiteOpacity(.white25)
            $0.textAlignment = .center
            $0.font = .offroad(style: .bothUpcomingNumRegular)
            $0.adjustsFontSizeToFitWidth = true
            $0.minimumScaleFactor = 0.5
        }
    }
    
    private func setupHierarchy() {
        addSubviews(
            backgroundImageView,
            nicknameLabel,
            characterNameView,
            characterMotionView,
            buttonStackView,
            titleView,
            questStackView
        )
        
        characterNameView.addSubview(characterNameLabel)
        
        #if DevTarget
        buttonStackView.addArrangedSubviews(
            chatButton,
            recommendButton,
            changeCharacterButton,
            diaryButton
        )
        diaryButton.addSubview(diaryUnreadDotView)
        #else
        buttonStackView.addArrangedSubviews(
            chatButton,
            shareButton,
            changeCharacterButton
        )
        #endif
        chatButton.addSubview(chatUnreadDotView)
        titleView.addSubviews(titleLabel, changeTitleButton)
        questStackView.addArrangedSubviews(recentQuestView, almostDoneQuestView)
        recentQuestView.addSubviews(recentQuestProgressView, recentQuestProgressLabel)
        almostDoneQuestView.addSubviews(almostDoneQuestProgressView, almostDoneQuestProgressLabel)
    }
    
    private func setupLayout() {
        backgroundImageView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }

        nicknameLabel.setContentHuggingPriority(.defaultHigh + 1, for: .vertical)
        nicknameLabel.setContentCompressionResistancePriority(.defaultHigh + 1, for: .vertical)
        nicknameLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(26)
            $0.leading.equalToSuperview().inset(24)
            $0.height.equalTo(29)
        }
        
        characterNameView.snp.makeConstraints {
            $0.top.equalTo(nicknameLabel.snp.bottom).offset(17)
            $0.leading.equalToSuperview().inset(24)
            $0.height.equalTo(35)
        }
        
        characterNameLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(17)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.top.equalTo(characterNameView.snp.top)
            $0.trailing.equalToSuperview().inset(24)
        }

        [chatButton, shareButton, changeCharacterButton, diaryButton].forEach { button in
            button.snp.makeConstraints {
                $0.size.equalTo(44)
            }
        }
        
        chatUnreadDotView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(2)
            $0.trailing.equalToSuperview().inset(4)
            $0.size.equalTo(8)
        }
        
        diaryUnreadDotView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(2)
            $0.trailing.equalToSuperview().inset(4)
            $0.size.equalTo(8)
        }
        
        characterMotionView.snp.makeConstraints {
            $0.top.equalTo(characterNameView.snp.bottom)
            $0.bottom.equalTo(titleView.snp.top)
            $0.horizontalEdges.equalToSuperview()
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
            $0.bottom.equalTo(safeAreaLayoutGuide).inset(55)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(195)
        }
        
        recentQuestProgressView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.width.equalTo(82)
        }
        
        recentQuestProgressLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.width.equalTo(70)
        }
        
        almostDoneQuestProgressView.snp.makeConstraints {
            $0.leading.equalToSuperview()
            $0.trailing.equalToSuperview().inset(15)
            $0.bottom.equalToSuperview().inset(57)
            $0.height.equalTo(9)
        }
        
        almostDoneQuestProgressLabel.snp.makeConstraints {
            $0.bottom.equalTo(almostDoneQuestProgressView.snp.top).offset(-28)
            $0.width.equalTo(140)
            $0.centerX.equalToSuperview()
        }
    }
    
    //MARK: - Func
    
    func changeMyTitleLabelText(text: String) {
        titleLabel.text = text
    }
    
    func updateAdventureInfo(nickname: String, baseImageUrl: String, characterName: String, emblemName: String) {
        nicknameLabel.text = "모험가 \(nickname)님"
        nicknameLabel.highlightText(targetText: nickname, font: .offroad(style: .iosProfileTitle))
        characterNameLabel.text = characterName
        titleLabel.text = emblemName
    }
    
    func showMotionImage(motionImageUrl: String) {
        characterMotionView.fetchMotionURLToAnimationView(motionUrlString: motionImageUrl)
    }
    
    func updateQuestInfo(recentQuestName: String, recentProgress: Int, recentCompleteCondition: Int, almostQuestName: String, almostprogress: Int, almostCompleteCondition: Int) {
        recentQuestView.setupDetailString(detailString: recentQuestName)
        almostDoneQuestView.setupDetailString(detailString: almostQuestName)
        
        recentQuestProgressLabel.text = "\(recentProgress)/\(recentCompleteCondition)"
        recentQuestProgressLabel.highlightText(targetText: "\(recentProgress)", font: .offroad(style: .bothRecentNumBold), color: .main(.main1))
        almostDoneQuestProgressLabel.text = "\(almostprogress) / \(almostCompleteCondition)"
        almostDoneQuestProgressLabel.highlightText(targetText: "\(almostprogress)", font: .offroad(style: .bothUpcomingNumBold), color: .main(.main1))
        
        
        let recentProgressValue = CGFloat(recentProgress)/CGFloat(recentCompleteCondition)
        let almostProgressValue = CGFloat(almostprogress)/CGFloat(almostCompleteCondition)
        
        recentQuestProgressView.setProgressView(progressValue: recentProgressValue)
        almostDoneQuestProgressView.setProgressView(progressValue: almostProgressValue)
    }
}
