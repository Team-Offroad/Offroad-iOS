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
    private let questProgressLabel = UILabel()
    private let chevronImageView = UIImageView(image: .icnQuestListExpendableCellChevron)
    
    private let questDescriptionLabel = UILabel()
    
    private let questInfoView = UILabel()
    private let checkBoxImageView = UIImageView(image: .icnQuestListCheckBox)
    private let questClearConditionLabel = UILabel()
    private lazy var stackView1 = UIStackView(arrangedSubviews: [checkBoxImageView, questClearConditionLabel])
    
    private let giftBoxImageVIew = UIImageView(image: .icnQuestListGiftBox)
    private let questRewardDescriptionLabel = UILabel()
    private lazy var stackView2 = UIStackView(arrangedSubviews: [giftBoxImageVIew, questRewardDescriptionLabel])
    
    private lazy var stackViewStack = UIStackView(arrangedSubviews: [stackView1, stackView2])
    
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
        
        detailContentView.addSubviews(
            questDescriptionLabel,
            questInfoView
        )
        
        questInfoView.addSubview(stackViewStack)
    }

    private func setupStyle() {
        contentView.backgroundColor = .main(.main3)
        contentView.roundCorners(cornerRadius: 5)
        
        questNameLabel.do { label in
            label.font = .offroad(style: .iosTextBold)
            label.textColor = .main(.main2)
            label.textAlignment = .left
            label.numberOfLines = 2
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
        
        [stackView1, stackView2].forEach { stackView in
            stackView.axis = .horizontal
            stackView.spacing = 6
            stackView.alignment = .center
            stackView.distribution = .fillProportionally
        }
        
        stackViewStack.do { stackView in
            stackView.axis = .vertical
            stackView.spacing = 4
            stackView.alignment = .fill
            stackView.distribution = .fillProportionally
        }
    }

    private func setupLayout() {
        mainContentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 60).isActive = true
        
        questNameLabel.setContentHuggingPriority(.init(251), for: .horizontal)
        questNameLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(18)
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalTo(questProgressLabel.snp.leading).offset(-7)
        }
        
        questProgressLabel.setContentHuggingPriority(
            questNameLabel.contentHuggingPriority(for: .horizontal) + 1,
            for: .horizontal
        )
        questProgressLabel.snp.makeConstraints { make in
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
        
        questInfoView.snp.makeConstraints { make in
            make.top.equalTo(questDescriptionLabel.snp.bottom).offset(14)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(18)
        }
        
        [checkBoxImageView, giftBoxImageVIew].forEach { imagView in
            imagView.widthAnchor.constraint(equalToConstant: 25).isActive = true
            imagView.heightAnchor.constraint(equalToConstant: 25).isActive = true
        }
        
        stackViewStack.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(9)
            make.horizontalEdges.equalToSuperview().inset(12)
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
