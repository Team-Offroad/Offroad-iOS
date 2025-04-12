//
//  QuestListExpandableCell.swift
//  Offroad-iOS
//
//  Created by 김민성 on 4/12/25.
//

import UIKit

import ExpandableCell
import SnapKit
import Then

final class QuestListExpandableCell: ExpandableCell, Shrinkable {
    
    let shrinkingAnimator: UIViewPropertyAnimator = .init(duration: 0.5, dampingRatio: 1)
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                shrink(scale: 0.97)
            } else {
                restore()
            }
        }
    }
    
    
    //MARK: - UI Properties
    
    private let questNameLabel = UILabel()
    private let spacer = UILayoutGuide()
    private let questProgressLabel = UILabel()
    private let chevronImageView = UIImageView(image: .icnQuestListExpendableCellChevron)
    
    private let questDescriptionLabel = UILabel()
    
    private let questInfoView = UILabel()
    private let checkBoxImageView = UIImageView(image: .icnQuestListCheckBox)
    private let giftBoxImageVIew = UIImageView(image: .icnQuestListGiftBox)
    private let questClearConditionLabel = UILabel()
    private let questRewardDescriptionLabel = UILabel()
    
    //MARK: - Life Cycle

    override init(frame: CGRect) {
        super.init(frame: frame)

        setupHierarchy()
        setupStyle()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
        questNameLabel.text = ""
        questProgressLabel.text = ""
        questDescriptionLabel.text = ""
        questClearConditionLabel.text = ""
        questRewardDescriptionLabel.text = ""
    }
    
    override func animateExpansion() {
        chevronImageView.transform = .init(rotationAngle: 0.99 * .pi)
        questDescriptionLabel.alpha = 1
        questInfoView.alpha = 1
    }
    
    override func animateCollapse() {
        chevronImageView.transform = .identity
        questDescriptionLabel.alpha = 0
        questInfoView.alpha = 0
    }
    
}

extension QuestListExpandableCell {
    
    //MARK: - Private Func

    private func setupHierarchy() {
        
        mainContentView.addSubviews(
            questNameLabel,
            questProgressLabel,
            chevronImageView
        )
        mainContentView.addLayoutGuide(spacer)
        
        detailContentView.addSubviews(
            questDescriptionLabel,
            questInfoView
        )
        
        questInfoView.addSubviews(
            checkBoxImageView,
            giftBoxImageVIew,
            questClearConditionLabel,
            questRewardDescriptionLabel
        )
    }

    private func setupStyle() {
        contentView.backgroundColor = .main(.main3)
        contentView.roundCorners(cornerRadius: 5)
        
        questNameLabel.do { label in
            label.font = .offroad(style: .iosTextBold)
            label.textColor = .main(.main2)
            label.textAlignment = .left
            label.numberOfLines = 0
        }
        
        questProgressLabel.do { label in
            label.font = .offroad(style: .iosHint)
            label.textColor = .sub(.sub2)
            label.textAlignment = .right
        }
        
        chevronImageView.do { imageView in
            imageView.contentMode = .scaleAspectFit
        }
        
        questDescriptionLabel.do { label in
            label.font = .offroad(style: .iosBoxMedi)
            label.textAlignment = .left
            label.numberOfLines = 0
            label.textColor = .grayscale(.gray400)
        }
        
        questInfoView.do { view in
            view.backgroundColor = .primary(.boxInfo)
            view.roundCorners(cornerRadius: 9)
        }

        checkBoxImageView.do { imageView in
            imageView.contentMode = .scaleAspectFit
        }
        
        giftBoxImageVIew.do { imageView in
            imageView.contentMode = .scaleAspectFit
        }
        
        questClearConditionLabel.do { label in
            label.font = .offroad(style: .iosBoxMedi)
            label.textColor = .grayscale(.gray400)
            label.numberOfLines = 0
            label.textAlignment = .left
        }
        
        questRewardDescriptionLabel.do { label in
            label.font = .offroad(style: .iosBoxMedi)
            label.textColor = .grayscale(.gray400)
            label.numberOfLines = 0
            label.textAlignment = .left
        }
    }

    private func setupLayout() {
        questNameLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(18)
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalTo(spacer.snp.leading)
        }
        
        spacer.widthAnchor.constraint(greaterThanOrEqualToConstant: 7).isActive = true
        
        questProgressLabel.snp.makeConstraints { make in
            make.leading.equalTo(spacer.snp.trailing)
            make.centerY.equalTo(questNameLabel)
            make.trailing.equalTo(chevronImageView.snp.leading)
        }

        chevronImageView.snp.makeConstraints { make in
            make.centerY.equalTo(questNameLabel)
            make.trailing.equalToSuperview()
            make.size.equalTo(44)
        }
        
        questDescriptionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        checkBoxImageView.snp.makeConstraints { make in
            make.centerY.equalTo(questClearConditionLabel)
            make.top.greaterThanOrEqualToSuperview().inset(9)
            make.leading.equalToSuperview().inset(12)
            make.size.equalTo(25)
        }
        
        giftBoxImageVIew.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(checkBoxImageView.snp.bottom).offset(4)
            make.centerY.equalTo(questRewardDescriptionLabel)
            make.leading.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(9)
            make.size.equalTo(25)
        }

        questClearConditionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(9)
            make.leading.equalTo(checkBoxImageView.snp.trailing).offset(6)
            make.trailing.equalToSuperview().inset(12)
        }
        
        questRewardDescriptionLabel.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(questClearConditionLabel.snp.bottom).offset(7)
            make.leading.equalTo(giftBoxImageVIew.snp.trailing).offset(6)
            // 피그마상으로는 22라고 되어있는데, 잘못된 것 같아 임의로 설정함.
            // 디자이너분들과 논의 후 확정 필요
            make.trailing.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(9)
        }
        
        questInfoView.snp.makeConstraints { make in
            make.top.equalTo(questDescriptionLabel.snp.bottom).offset(14)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(18)
        }
    }

    //MARK: - Func

    func configureCell(with quest: Quest) {
        questNameLabel.text = quest.questName
        questProgressLabel.text = "달성도 (\(quest.currentCount)/\(quest.totalCount))"
        questProgressLabel.highlightText(targetText: "달성도", color: .grayscale(.gray400))
        
        questDescriptionLabel.text = quest.description == "" ? "데이터 없음" : quest.description
        
        questClearConditionLabel.text = quest.requirement == "" ? "데이터 없음" : quest.requirement
        questRewardDescriptionLabel.text = quest.reward == "" ? "데이터 없음" : quest.reward
        
        contentView.layoutIfNeeded()
    }
    
}
