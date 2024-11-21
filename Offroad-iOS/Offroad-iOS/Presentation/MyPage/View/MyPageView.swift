//
//  MyPageView.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 8/6/24.
//

import UIKit

import SnapKit
import Then

final class MyPageView: UIView {
    
    //MARK: - Properties
    
    let backgroundViewWidth = UIScreen.main.bounds.width - 48

    //MARK: - UI Properties
    
    private let myPageScrollView = UIScrollView()
    private let myPageContentView = UIView()
    private let nicknameLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let flagImageView = UIImageView(image: UIImage(resource: .imgFlag))
    private let labelStackView = UIStackView()
    private let profileBackgroundView = UIView()
    private let characterProfileImageView = UIImageView()
    private let adventureDaysLabel = UILabel()
    private let adventureTitleImageView = UIImageView(image: UIImage(resource: .imgTitleFrame))
    private let adventureTitleLabel = UILabel()
    private let adventureStackView = UIStackView()
    private let dottedLineView = UIView()
    private let questPlaceBackgroundView = UIView()
    private let completedQuestsCountLabel = UILabel()
    private let visitedPlacesCountLabel = UILabel()
    private let dividerView = UIView()
    let characterButton = MyPageCustomButton(titleString: "획득 캐릭터", backgroundImage: .btnCharacter)
    let couponButton = MyPageCustomButton(titleString: "획득 쿠폰", backgroundImage: .btnCoupon)
    let titleButton = MyPageCustomButton(titleString: "획득 칭호", backgroundImage: .btnTitle)
    let settingButton = MyPageCustomButton(titleString: "설정", backgroundImage: .btnSetting)
    private let horizontalStackView1 = UIStackView()
    private let horizontalStackView2 = UIStackView()
    private let verticalStackView = UIStackView()
        
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

extension MyPageView {
    
    // MARK: - Layout
    
    private func setupStyle() {
        backgroundColor = .primary(.listBg)
        
        myPageScrollView.do {
            $0.backgroundColor = .clear
            $0.showsVerticalScrollIndicator = false
        }
        
        myPageContentView.do {
            $0.backgroundColor = .clear
        }
        
        nicknameLabel.do {
            $0.text = " "
            $0.font = .offroad(style: .bothSubtitle3)
            $0.textColor = .main(.main2)
            $0.textAlignment = .center
        }
        
        descriptionLabel.do {
            $0.text = "모험을 떠나봐요!"
            $0.font = .offroad(style: .bothSubtitle3)
            $0.textColor = .main(.main2)
            $0.textAlignment = .center
        }
        
        labelStackView.do {
            $0.axis = .vertical
            $0.spacing = 8
            $0.alignment = .leading
        }
        
        [profileBackgroundView, questPlaceBackgroundView].forEach {
            $0.backgroundColor = .main(.main1)
            $0.roundCorners(cornerRadius: 10)
        }
        
        characterProfileImageView.do {
            $0.contentMode = .scaleAspectFit
        }
        
        adventureDaysLabel.do {
            $0.textColor = .main(.main2)
            $0.textAlignment = .center
            $0.font = .offroad(style: .iosHint)
        }
        
        adventureTitleLabel.do {
            $0.textColor = .sub(.sub)
            $0.textAlignment = .center
            $0.font = .offroad(style: .iosTextContents)
            $0.adjustsFontSizeToFitWidth = true
            $0.minimumScaleFactor = 0.5
        }
        
        adventureStackView.do {
            $0.axis = .vertical
            $0.spacing = 10
            $0.alignment = .leading
        }
        
        dottedLineView.do {
            let shapeLayer = CAShapeLayer()
            shapeLayer.strokeColor = UIColor.primary(.stroke).cgColor
            shapeLayer.lineWidth = 0.5
            shapeLayer.lineDashPattern = [3, 3]
            
            let path = CGMutablePath()
            path.addLines(between: [CGPoint(x: 0, y: 0),
                                    CGPoint(x: backgroundViewWidth - 50, y: 0)])
            shapeLayer.path = path
            
            $0.layer.addSublayer(shapeLayer)
        }
        
        completedQuestsCountLabel.do {
            $0.textColor = .main(.main2)
            $0.textAlignment = .center
            $0.font = .offroad(style: .iosTextContentsSmall)
        }
        
        visitedPlacesCountLabel.do {
            $0.textColor = .main(.main2)
            $0.textAlignment = .center
            $0.font = .offroad(style: .iosTextContentsSmall)
        }
        
        dividerView.do {
            $0.backgroundColor = .primary(.stroke)
        }
        
        [characterButton, couponButton, titleButton, settingButton].forEach {
            $0.roundCorners(cornerRadius: 10)
        }
        
        [horizontalStackView1, horizontalStackView2].forEach {
            $0.axis = .horizontal
            $0.distribution = .fillEqually
            $0.spacing = 13
        }
        
        verticalStackView.do {
            $0.axis = .vertical
            $0.spacing = 15
        }
    }
    
    private func setupHierarchy() {
        addSubview(myPageScrollView)
        myPageScrollView.addSubview(myPageContentView)
        myPageContentView.addSubviews(
            labelStackView,
            flagImageView,
            profileBackgroundView,
            questPlaceBackgroundView,
            dottedLineView,
            verticalStackView
        )
        
        labelStackView.addArrangedSubviews(nicknameLabel, descriptionLabel)
        
        profileBackgroundView.addSubviews(
            characterProfileImageView,
            adventureStackView
        )
        
        adventureStackView.addArrangedSubviews(adventureDaysLabel, adventureTitleImageView)
        adventureTitleImageView.addSubview(adventureTitleLabel)
        
        questPlaceBackgroundView.addSubviews(
            dividerView,
            completedQuestsCountLabel,
            visitedPlacesCountLabel
        )
        
        horizontalStackView1.addArrangedSubviews(characterButton, couponButton)
        horizontalStackView2.addArrangedSubviews(titleButton, settingButton)
        verticalStackView.addArrangedSubviews(horizontalStackView1, horizontalStackView2)
    }
    
    private func setupLayout() {
        myPageScrollView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
        
        myPageContentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
            $0.bottom.equalTo(verticalStackView.snp.bottom).offset(62)
        }
        
        labelStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(52)
            $0.leading.equalToSuperview().inset(24)
        }
        
        flagImageView.snp.makeConstraints {
            $0.leading.equalTo(descriptionLabel.snp.trailing).offset(12)
            $0.centerY.equalTo(descriptionLabel.snp.centerY)
        }
        
        profileBackgroundView.snp.makeConstraints {
            $0.top.equalTo(labelStackView.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(122)
        }
        
        characterProfileImageView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(25)
            $0.size.equalTo(100)
        }
        
        adventureStackView.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(36)
        }
        
        adventureTitleLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.leading.equalToSuperview().inset(16)
            $0.width.equalTo(107)
        }
        
        questPlaceBackgroundView.snp.makeConstraints {
            $0.top.equalTo(profileBackgroundView.snp.bottom)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(44)
        }
        
        dottedLineView.snp.makeConstraints {
            $0.top.equalTo(profileBackgroundView.snp.bottom)
            $0.horizontalEdges.equalToSuperview().inset(48)
            $0.height.equalTo(0.5)
        }
        
        dividerView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.height.equalTo(20)
            $0.width.equalTo(1)
        }
        
        completedQuestsCountLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.centerX.equalToSuperview().offset(-backgroundViewWidth / 4)
        }
        
        visitedPlacesCountLabel.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.centerX.equalToSuperview().offset(backgroundViewWidth / 4)
        }
        
        [characterButton, couponButton, titleButton, settingButton].forEach {
            $0.snp.makeConstraints {
                $0.height.equalTo(138)
            }
        }
        
        verticalStackView.snp.makeConstraints {
            $0.top.equalTo(questPlaceBackgroundView.snp.bottom).offset(18)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
    }
    
    //MARK: - Func
    
    func bindData(data: UserInfoData) {
        nicknameLabel.text = "\(data.nickname)님"
        nicknameLabel.highlightText(targetText: data.nickname, font: .offroad(style: .iosProfileTitle))
        
        characterProfileImageView.fetchSvgURLToImageView(svgUrlString: data.characterImageUrl)

        adventureDaysLabel.text = "\(String(data.elapsedDay))일 째 모험을 떠나는 중"
        adventureDaysLabel.highlightText(targetText: String(data.elapsedDay), font: .offroad(style: .iosTextContents), color: .sub(.sub2))

        adventureTitleLabel.text = data.currentEmblem
        
        completedQuestsCountLabel.text = "달성 퀘스트 수 \(String(data.completeQuestCount))"
        completedQuestsCountLabel.highlightText(targetText: String(data.completeQuestCount), font: .offroad(style: .iosTooltipNumber), color: .sub(.sub2))
        
        visitedPlacesCountLabel.text = "방문 장소 수 \(String(data.visitedPlaceCount))"
        visitedPlacesCountLabel.highlightText(targetText: String(data.visitedPlaceCount), font: .offroad(style: .iosTooltipNumber), color: .sub(.sub2))
    }
}
