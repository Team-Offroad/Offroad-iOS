//
//  CourseQuestCollectionViewCell.swift
//  Offroad-iOS
//
//  Created by  정지원 on 3/11/25.
//
#if DevTarget
import UIKit

import ExpandableCell
import SnapKit

class CourseQuestCollectionViewCell: ExpandableCell, Shrinkable {
    
    // MARK: - Properties
    
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
    
    // MARK: - UI Components
    private let ddayBubbleView = UIImageView()
    private let ddayLabel = UILabel()
    
    private let courseQuestNameLabel = UILabel()
    private let courseQuestProgressLabel = UILabel()
    private let chevronImageView = UIImageView(image: .icnQuestListExpendableCellChevron)
    
    private let courseQuestDescriptionLabel = UILabel()
    
    private let courseQuestInfoView = UIView()
    private var checkBoxImageViews: [UIImageView] = []
    private let courseQuestListStackView = UIStackView()
    private let detailButton = ShrinkableButton()
    
    // MARK: - Initializer
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.snp.makeConstraints { make in
                make.top.equalToSuperview().inset(17) // ddayBubbleView 높이만큼
                make.leading.trailing.bottom.equalToSuperview()
            }
        
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
    
    override func animateExpansion() {
        courseQuestDescriptionLabel.alpha = 1
        courseQuestInfoView.alpha = 1
        chevronImageView.transform = CGAffineTransform(rotationAngle: .pi * 0.999)
    }
    
    override func animateCollapse() {
        courseQuestDescriptionLabel.alpha = 0
        courseQuestInfoView.alpha = 0
        chevronImageView.transform = .identity
    }
    
}

// MARK: - UI Setup

extension CourseQuestCollectionViewCell {
    
    private func setupHierarchy() {
        addSubview(ddayBubbleView)
        ddayBubbleView.addSubview(ddayLabel)

        mainContentView.addSubviews(
            courseQuestNameLabel,
            courseQuestProgressLabel,
            chevronImageView
        )
        
        detailContentView.addSubviews(
            courseQuestDescriptionLabel,
            courseQuestInfoView,
            detailButton
        )
        
        courseQuestInfoView.addSubview(courseQuestListStackView)
    }
    
    private func setupStyle() {
        contentView.backgroundColor = .white
        contentView.roundCorners(cornerRadius: 8)
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.systemGray4.cgColor
        
        ddayBubbleView.do { imageView in
            imageView.image = UIImage.icnQuestListDdayBubble
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = false
        }

        ddayLabel.do {
            $0.text = "D-10"
            $0.font = .offroad(style: .iosTextBold)
            $0.textColor = .sub(.sub480)
            $0.textAlignment = .center
        }
        
        courseQuestNameLabel.do { label in
            label.font = .offroad(style: .iosTextBold)
            label.textColor = .main(.main2)
            label.textAlignment = .left
            label.numberOfLines = 0
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
        
        detailButton.do {
            $0.setTitle("자세히 보기", for: .normal)
            $0.setTitleColor(.main(.main1), for: .normal)
            $0.titleLabel?.font = .offroad(style: .iosBtnSmall)
            $0.backgroundColor = .sub(.sub)
            $0.roundCorners(cornerRadius: 5)
        }
    }
    
    private func setupLayout() {
        mainContentView.heightAnchor.constraint(greaterThanOrEqualToConstant: 60).isActive = true
        mainContentView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(17)
        }
        
        ddayBubbleView.snp.makeConstraints { make in
            make.leading.equalToSuperview()
            make.width.equalTo(76)
            make.height.equalTo(44.4)
        }

        ddayLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10.7)
            make.centerX.equalToSuperview()
        }
        
        courseQuestNameLabel.setContentHuggingPriority(
            courseQuestProgressLabel.contentHuggingPriority(for: .horizontal) - 1,
            for: .horizontal
        )
        courseQuestNameLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(18)
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalTo(courseQuestProgressLabel.snp.leading).offset(-7)
        }
        
        courseQuestProgressLabel.setContentCompressionResistancePriority(
            courseQuestNameLabel.contentCompressionResistancePriority(for: .horizontal) + 1,
            for: .horizontal
        )
        courseQuestProgressLabel.snp.makeConstraints { make in
            make.centerY.equalTo(courseQuestNameLabel)
            make.trailing.equalTo(chevronImageView.snp.leading)
        }
        
        chevronImageView.snp.makeConstraints { make in
            make.centerY.equalTo(courseQuestNameLabel)
            make.trailing.equalToSuperview()
            make.size.equalTo(44)
        }
        
        courseQuestDescriptionLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        courseQuestListStackView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(12)
            make.verticalEdges.equalToSuperview().inset(9)
        }
        
        courseQuestInfoView.snp.makeConstraints { make in
            make.top.equalTo(courseQuestDescriptionLabel.snp.bottom).offset(14)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        detailButton.snp.makeConstraints { make in
            make.height.equalTo(44)
            make.top.equalTo(courseQuestInfoView.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.bottom.equalToSuperview().inset(16)
        }
    }
    
    // MARK: - Configure Cell
    
    func configureCell(with quest: CourseQuest) {
        courseQuestNameLabel.text = quest.title
        courseQuestProgressLabel.text = "달성도 (\(quest.progress))"
        courseQuestProgressLabel.highlightText(targetText: "달성도", color: .grayscale(.gray400))
        courseQuestDescriptionLabel.text = quest.description
        courseQuestListStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        let checkBoxImage: UIImage = .icnQuestListCheckBox
        for questDetail in quest.quests {
            let questStackView = IconLabelStackView(icon: checkBoxImage, text: "\(questDetail.locationName): \(questDetail.mission)")
            courseQuestListStackView.addArrangedSubview(questStackView)
        }
        
        let rewardStackView = IconLabelStackView(icon: checkBoxImage, text: "보상: \(quest.reward)")
        courseQuestListStackView.addArrangedSubview(rewardStackView)
        
        contentView.layoutIfNeeded()
    }
}
#endif

