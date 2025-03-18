//
//  CourseQuestCollectionViewCell.swift
//  Offroad-iOS
//
//  Created by  정지원 on 3/11/25.
//
#if DevTarget
import UIKit

import SnapKit

class CourseQuestCollectionViewCell: ShrinkableCollectionViewCell {
    
    // MARK: - Properties
    
    private let collectionViewHorizontalSectionInset: CGFloat = 24
    private lazy var widthConstraint = contentView.widthAnchor.constraint(
        equalToConstant: UIScreen.main.bounds.width - collectionViewHorizontalSectionInset * 2
    )
    
    private lazy var expandedBottomConstraint = courseQuestInfoView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -18)
    private lazy var shrinkedBottomConstraint = courseQuestNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -18)
    
    override var isSelected: Bool {
        didSet { setAppearance() }
    }
    
    // MARK: - UI Components
    
    private let courseQuestNameLabel = UILabel()
    private let courseQuestProgressLabel = UILabel()
    private let chevronImageView = UIImageView(image: .icnQuestListExpendableCellChevron)
    
    private let courseQuestDescriptionLabel = UILabel()
    
    private let courseQuestInfoView = UIView()
    private var checkBoxImageViews: [UIImageView] = []
    private let courseQuestListStackView = UIStackView()
    
    // MARK: - Initializer
    
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
        
        courseQuestNameLabel.text = ""
        courseQuestProgressLabel.text = ""
        courseQuestDescriptionLabel.text = ""
        
        courseQuestListStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
}

// MARK: - UI Setup

extension CourseQuestCollectionViewCell {
    
    private func setupHierarchy() {
        contentView.addSubviews(
            courseQuestNameLabel,
            courseQuestProgressLabel,
            chevronImageView,
            courseQuestDescriptionLabel,
            courseQuestInfoView
        )
        
        courseQuestInfoView.addSubview(courseQuestListStackView)
    }
    
    private func setupStyle() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.systemGray4.cgColor
        
        courseQuestNameLabel.do { label in
            label.font = .offroad(style: .iosTextBold)
            label.textColor = .main(.main2)
            label.textAlignment = .left
            label.numberOfLines = 1
        }
        
        courseQuestProgressLabel.do { label in
            label.font = .offroad(style: .iosHint)
            label.textColor = .sub(.sub2)
            label.textAlignment = .right
        }
        
        chevronImageView.do { imageView in
            imageView.contentMode = .scaleAspectFit
        }
        
        courseQuestDescriptionLabel.do { label in
            label.font = .offroad(style: .iosBoxMedi)
            label.textAlignment = .left
            label.numberOfLines = 0
            label.textColor = .grayscale(.gray400)
        }
        
        courseQuestInfoView.do { view in
            view.backgroundColor = .primary(.boxInfo)
            view.roundCorners(cornerRadius: 9)
        }
        
        courseQuestListStackView.do { stackView in
            stackView.axis = .vertical
            stackView.spacing = 6
            stackView.alignment = .leading
            stackView.distribution = .equalSpacing
        }
    }
    
    private func setupLayout() {
        widthConstraint.priority = .defaultHigh
        widthConstraint.isActive = true
        
        courseQuestNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(18)
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalTo(courseQuestProgressLabel.snp.leading).offset(-7)
        }
        
        courseQuestProgressLabel.snp.makeConstraints { make in
            make.centerY.equalTo(courseQuestNameLabel)
            make.trailing.equalTo(chevronImageView.snp.leading).offset(-10)
        }
        
        chevronImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(8)
            make.trailing.equalToSuperview()
            make.size.equalTo(44)
        }
        
        courseQuestDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(courseQuestNameLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        courseQuestListStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(12)
            make.verticalEdges.equalToSuperview().inset(9)
        }
        
        courseQuestInfoView.snp.makeConstraints { make in
            make.top.equalTo(courseQuestDescriptionLabel.snp.bottom).offset(14)
            make.horizontalEdges.equalToSuperview().inset(12)
        }
        
        expandedBottomConstraint.priority = .defaultLow
        shrinkedBottomConstraint.priority = .defaultLow
        
        expandedBottomConstraint.isActive = isSelected
        shrinkedBottomConstraint.isActive = !isSelected
    }
    
    private func setAppearance() {
        expandedBottomConstraint.isActive = isSelected
        shrinkedBottomConstraint.isActive = !isSelected
        
        courseQuestDescriptionLabel.isHidden = !isSelected
        courseQuestInfoView.isHidden = !isSelected
        
        let rotationTransform = isSelected ? CGAffineTransform(rotationAngle: .pi * 0.999) : CGAffineTransform.identity
        chevronImageView.transform = rotationTransform
        contentView.layoutIfNeeded()
    }
    
    // MARK: - Configure Cell
    
    func configureCell(with quest: CourseQuest) {
        courseQuestNameLabel.text = quest.title
        courseQuestProgressLabel.text = "달성도 (\(quest.progress))"
        courseQuestProgressLabel.highlightText(targetText: "달성도", color: .grayscale(.gray400))
        courseQuestDescriptionLabel.text = quest.description
        courseQuestListStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for questDetail in quest.quests {
            let questStackView = IconLabelStackView(icon: .icnQuestListCheckBox, text: "\(questDetail.locationName): \(questDetail.mission)")
            courseQuestListStackView.addArrangedSubview(questStackView)
        }
        
        let rewardStackView = IconLabelStackView(icon: .icnQuestListGiftBox, text: "보상: \(quest.reward)")
        courseQuestListStackView.addArrangedSubview(rewardStackView)
        
        contentView.layoutIfNeeded()
    }
}
#endif

