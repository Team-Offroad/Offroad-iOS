//
//  CourseQuestCollectionViewCell.swift
//  Offroad-iOS
//
//  Created by  정지원 on 3/11/25.
//
#if DevTarget
import UIKit

import SnapKit

class CourseQuestCollectionViewCell: UICollectionViewCell {
    
    // MARK: - Properties
    
    private let collectionViewHorizontalSectionInset: CGFloat = 24
    private lazy var widthConstraint = contentView.widthAnchor.constraint(
        equalToConstant: UIScreen.main.bounds.width - collectionViewHorizontalSectionInset * 2
    )
    
    private lazy var expandedBottomConstraint = questInfoView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -18)
    private lazy var shrinkedBottomConstraint = questNameLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -18)
    
    override var isSelected: Bool {
        didSet { setAppearance() }
    }
    
    // MARK: - UI Components
    
    private let questNameLabel = UILabel()
    private let questProgressLabel = UILabel()
    private let chevronImageView = UIImageView(image: .icnQuestListExpendableCellChevron)
    
    private let questDescriptionLabel = UILabel()
    
    private let questInfoView = UIView()
    private let questListStackView = UIStackView()
    private let questRewardDescriptionLabel = UILabel()
    
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
        
        questNameLabel.text = ""
        questProgressLabel.text = ""
        questDescriptionLabel.text = ""
        questRewardDescriptionLabel.text = ""
        
        questListStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
    }
}

// MARK: - UI Setup

extension CourseQuestCollectionViewCell {
    
    private func setupHierarchy() {
        contentView.addSubviews(
            questNameLabel,
            questProgressLabel,
            chevronImageView,
            questDescriptionLabel,
            questInfoView
        )
        
        questInfoView.addSubviews(
            questListStackView,
            questRewardDescriptionLabel
        )
    }
    
    private func setupStyle() {
        contentView.backgroundColor = .white
        contentView.layer.cornerRadius = 8
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.systemGray4.cgColor
        
        questNameLabel.do { label in
            label.font = .boldSystemFont(ofSize: 16)
            label.textColor = .black
            label.textAlignment = .left
            label.numberOfLines = 1
        }
        
        questProgressLabel.do { label in
            label.font = .systemFont(ofSize: 14)
            label.textColor = .gray
            label.textAlignment = .right
        }
        
        chevronImageView.do { imageView in
            imageView.contentMode = .scaleAspectFit
            imageView.tintColor = .gray
        }
        
        questDescriptionLabel.do { label in
            label.font = .systemFont(ofSize: 14)
            label.textAlignment = .left
            label.numberOfLines = 0
            label.lineBreakMode = .byWordWrapping
            label.textColor = .darkGray
        }
        
        questInfoView.do { view in
            view.backgroundColor = UIColor.systemGray5
            view.layer.cornerRadius = 8
        }
        
        questListStackView.do { stackView in
            stackView.axis = .vertical
            stackView.spacing = 6
            stackView.alignment = .leading
            stackView.distribution = .equalSpacing
        }
        
        questRewardDescriptionLabel.do { label in
            label.font = .systemFont(ofSize: 14)
            label.textColor = .black
            label.numberOfLines = 0
            label.lineBreakMode = .byWordWrapping
        }
    }
    
    private func setupLayout() {
        widthConstraint.priority = .defaultHigh
        widthConstraint.isActive = true
        
        questNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(18)
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalTo(questProgressLabel.snp.leading).offset(-7)
        }
        
        questProgressLabel.snp.makeConstraints { make in
            make.centerY.equalTo(questNameLabel)
            make.trailing.equalTo(chevronImageView.snp.leading).offset(-10)
        }
        
        chevronImageView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalTo(questNameLabel)
            make.size.equalTo(CGSize(width: 24, height: 24))
        }
        
        questDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(questNameLabel.snp.bottom).offset(8)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        questListStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.leading.trailing.equalToSuperview().inset(12)
        }
        
        questRewardDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(questListStackView.snp.bottom).offset(8)
            make.leading.trailing.equalToSuperview().inset(12)
            make.bottom.equalToSuperview().inset(10)
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
        
        let rotationTransform = isSelected ? CGAffineTransform(rotationAngle: .pi) : CGAffineTransform.identity
        UIView.animate(withDuration: 0.3) {
            self.chevronImageView.transform = rotationTransform
        }
        contentView.layoutIfNeeded()
    }
    
    // MARK: - Configure Cell
    
    func configureCell(with quest: CourseQuest) {
        questNameLabel.text = quest.title
        questProgressLabel.text = "달성도: \(quest.progress)"
        questDescriptionLabel.text = quest.description
        questRewardDescriptionLabel.text = "보상: \(quest.reward)"
        
        questListStackView.arrangedSubviews.forEach { $0.removeFromSuperview() }
        
        for questDetail in quest.quests {
            let questLabel = UILabel()
            questLabel.text = "🏁 \(questDetail.locationName): \(questDetail.mission)"
            questLabel.font = .systemFont(ofSize: 14)
            questLabel.textColor = .black
            questLabel.numberOfLines = 0
            questLabel.lineBreakMode = .byWordWrapping
            questListStackView.addArrangedSubview(questLabel)
        }
        
        contentView.layoutIfNeeded()
    }
}
#endif

