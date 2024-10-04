//
//  QuestListCollectionViewCell.swift
//  Offroad-iOS
//
//  Created by 김민성 on 8/10/24.
//

import UIKit

class QuestListCollectionViewCell: UICollectionViewCell {

    //MARK: - Properties

    private let collectionViewHorizontalSectionInset: CGFloat = 24
    private lazy var widthConstraint = contentView.widthAnchor.constraint(
        equalToConstant: UIScreen.current.bounds.width - collectionViewHorizontalSectionInset * 2
    )
    private lazy var expandedBottomConstraint = questInfoView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -18)
    private lazy var shrinkedBottomConstraint = questNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -18)

    override var isSelected: Bool {
        didSet { setAppearance() }
    }

    //MARK: - UI Properties
    
    private let questNameLabel = UILabel()
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

}

extension QuestListCollectionViewCell {

    //MARK: - Private Func

    private func setupHierarchy() {
        contentView.addSubviews(
            questNameLabel,
            questProgressLabel,
            chevronImageView,
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
            label.numberOfLines = 1
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
        // (이슈 해결 후 삭제 예정)
        // widthConstraint의 priority를 .defaultHigh로 설정하면 첫 번째 셀의 가로 길이가 collectionView를 넘어간다.
        // 이 priority를 .defaultHigh가 아닌 UILayoutPriority.init(1000)으로 설정하면 해당 문제가 해결됨.
        // 왜 그런지 공부하기
        widthConstraint.priority = .init(999)
        widthConstraint.isActive = true

        questNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(18)
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalTo(questProgressLabel.snp.leading).offset(-7)
        }
        questNameLabel.setContentCompressionResistancePriority(.init(0), for: .horizontal)
        
        questProgressLabel.snp.makeConstraints { make in
            make.centerY.equalTo(questNameLabel)
            make.trailing.equalTo(chevronImageView.snp.leading)
        }
        questProgressLabel.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)

        chevronImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.trailing.equalToSuperview()
            make.size.equalTo(44)
        }
        
        questDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(questNameLabel.snp.bottom).offset(18)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        checkBoxImageView.snp.makeConstraints { make in
            make.centerY.equalTo(questClearConditionLabel)
            make.top.greaterThanOrEqualTo(questInfoView.snp.top).inset(9)
            make.leading.equalToSuperview().inset(12)
            make.size.equalTo(25)
        }
        
        giftBoxImageVIew.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(checkBoxImageView.snp.bottom).offset(4)
            make.leading.equalToSuperview().inset(12)
            make.bottom.lessThanOrEqualTo(questInfoView.snp.bottom).inset(9)
            make.size.equalTo(25)
        }

        questClearConditionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(9)
            make.leading.equalTo(checkBoxImageView.snp.trailing).offset(6)
            // 피그마상으로는 22라고 되어있는데, 잘못된 것 같아 임의로 설정함.
            // 디자이너분들과 논의 후 확정 필요
            make.trailing.equalToSuperview().inset(12)
        }
        
        questRewardDescriptionLabel.snp.makeConstraints { make in
            make.centerY.equalTo(giftBoxImageVIew)
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
        }
        
        expandedBottomConstraint.priority = .defaultLow
        shrinkedBottomConstraint.priority = .defaultLow

        expandedBottomConstraint.isActive = isSelected
        shrinkedBottomConstraint.isActive = !isSelected
    }

    private func setAppearance() {
        expandedBottomConstraint.isActive = isSelected
        shrinkedBottomConstraint.isActive = !isSelected

        questDescriptionLabel.isHidden = !isSelected
        questInfoView.isHidden = !isSelected
        
        let rotationTransform = isSelected ? CGAffineTransform(rotationAngle: .pi * 0.999) : CGAffineTransform.identity
        chevronImageView.transform = rotationTransform
        contentView.layoutIfNeeded()
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
