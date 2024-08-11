//
//  QuestListCollectionViewCell.swift
//  Offroad-iOS
//
//  Created by 김민성 on 8/10/24.
//

import UIKit

class QuestListCollectionViewCell: UICollectionViewCell {

    //MARK: - Properties

    let collectionViewHorizontalSectionInset: CGFloat = 24
    lazy var widthConstraint = contentView.widthAnchor.constraint(
        equalToConstant: UIScreen.current.bounds.width - collectionViewHorizontalSectionInset * 2
    )
    lazy var expandedBottomConstraint = questInfoView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -18)
    lazy var shrinkedBottomConstraint = questNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -18)

    override var isSelected: Bool {
        didSet { setAppearance() }
    }

    //MARK: - UI Properties
    
    let questNameLabel = UILabel()
    let questProgressLabel = UILabel()
    // 지금은 파일이 없어 에러가 뜹니다.
    // 장소 목록 뷰 PR 올린 내용 중에 해당 파일이 추가되어있습니다.
    // 해당 브랜치를 머지하면 에러가 발생하지 않습니다.
    //let chevronImageView = UIImageView(image: .icnPlaceListExpendableCellChevron)
    let chevronImageView = UIImageView(image: .init(systemName: "chevron.down"))
    
    let questDescriptionLabel = UILabel()
    
    let questInfoView = UILabel()
    // 아래 두 이미지뷰의 이미지는 임시로 SFSymbol 사용함. 추후 변경 예정
    let checkBoxImageView = UIImageView(image: .icnQuestListCheckBox)
    let giftBoxImageVIew = UIImageView(image: .icnQuestListGiftBox)
    let questClearConditionLabel = UILabel()
    let questRewardDescriptionLabel = UILabel()

    //MARK: - Life Cycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        print("cell이 생성됨")

        setupHierarchy()
        setupStyle()
        setupLayout()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        print("cell이 사라짐")
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        
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
        contentView.layer.borderColor = UIColor.clear.cgColor
        
        questNameLabel.do { label in
            label.font = .offroad(style: .iosTextBold)
            label.textColor = .main(.main2)
            label.textAlignment = .left
            label.numberOfLines = 1
        }
        
        questProgressLabel.do { label in
            label.font = .offroad(style: .iosHint)
            label.textColor = .sub(.sub2)
        }
        
        chevronImageView.do { imageView in
            imageView.contentMode = .scaleAspectFit
        }
        
        questDescriptionLabel.do { label in
            // 추후 FontLiteral에 ios_box_medi가 추가되면 적용 요망
            label.font = .pretendardFont(ofSize: 14, weight: .medium)
            label.textAlignment = .left
            label.numberOfLines = 0
            label.textColor = .grayscale(.gray400)
        }
        
        questInfoView.do { view in
            // 추후 ColorLiteral로 변경 요망
            view.backgroundColor = .init(hexCode: "FFF5EA")
            view.roundCorners(cornerRadius: 9)
        }

        checkBoxImageView.do { imageView in
            imageView.contentMode = .scaleAspectFit
        }
        
        giftBoxImageVIew.do { imageView in
            imageView.contentMode = .scaleAspectFit
        }
        
        questClearConditionLabel.do { label in
            // 추후 FontLiteral에 ios_box_medi가 추가되면 적용 요망
            label.font = .pretendardFont(ofSize: 14, weight: .medium)
            label.textColor = .grayscale(.gray400)
            label.numberOfLines = 0
            label.textAlignment = .left
        }
        
        questRewardDescriptionLabel.do { label in
            // 추후 FontLiteral에 ios_box_medi가 추가되면 적용 요망
            label.font = .pretendardFont(ofSize: 14, weight: .medium)
            label.textColor = .grayscale(.gray400)
            label.numberOfLines = 0
            label.textAlignment = .left
        }
        
    }

    private func setupLayout() {
        // widthConstraint의 priority를 .defaultHigh로 설정하면 첫 번째 셀의 가로 길이가 collectionView를 넘어간다.
        // 이 priority를 .defaultHigh가 아닌 UILayoutPriority.init(1000)으로 설정하면 해당 문제가 해결됨.
        // 왜 그런지 공부하기
        widthConstraint.priority = .init(1000)
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
            //make.top.equalToSuperview().inset(9)
            make.leading.equalToSuperview().inset(12)
            make.size.equalTo(25)
        }
        
        giftBoxImageVIew.snp.makeConstraints { make in
            //make.centerY.equalTo(questRewardDescriptionLabel)
            //make.top.equalTo(checkBoxImageView.snp.bottom).offset(4)
            make.top.greaterThanOrEqualTo(checkBoxImageView.snp.bottom).offset(4)
            make.leading.equalToSuperview().inset(12)
            make.size.equalTo(25)
        }

        questClearConditionLabel.snp.makeConstraints { make in
            //make.centerY.equalTo(checkBoxImageView)
            // 9 from top
            make.top.equalToSuperview().inset(9)
            make.leading.equalTo(checkBoxImageView.snp.trailing).offset(6)
            // 피그마상으로는 22라고 되어있는데, 잘못된 것 같아 임의로 조정함.
            make.trailing.equalToSuperview().inset(12)
        }
        
        questRewardDescriptionLabel.snp.makeConstraints { make in
            make.centerY.equalTo(giftBoxImageVIew)
            // 7 from top
            //make.top.equalTo(questClearConditionLabel.snp.bottom).offset(7)
            make.top.greaterThanOrEqualTo(questClearConditionLabel.snp.bottom).offset(7)
            
            make.leading.equalTo(giftBoxImageVIew.snp.trailing).offset(6)
            // 피그마상으로는 22라고 되어있는데, 잘못된 것 같아 임의로 조정함.
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
        contentView.layer.borderWidth = isSelected ? 1 : 0
        expandedBottomConstraint.isActive = isSelected
        shrinkedBottomConstraint.isActive = !isSelected

        let rotationTransform = isSelected ? CGAffineTransform(rotationAngle: .pi * 0.999) : CGAffineTransform.identity
        chevronImageView.transform = rotationTransform
        contentView.layoutIfNeeded()
    }

    //MARK: - Func

    func configureCell(with quest: QuestDTO) {
        questNameLabel.text = quest.title
        questProgressLabel.text = "달성도 (\(quest.process)/\(quest.totalProcess))"
        questProgressLabel.highlightText(targetText: "달성도", color: .grayscale(.gray400))
        
        questDescriptionLabel.text = quest.questDescription
        
        questClearConditionLabel.text = quest.questClearDescription
        questRewardDescriptionLabel.text = quest.questRewardDescription
        
        contentView.layoutIfNeeded()
    }

}
