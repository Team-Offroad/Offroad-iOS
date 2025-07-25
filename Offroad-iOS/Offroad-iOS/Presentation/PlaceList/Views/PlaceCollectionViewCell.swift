//
//  PlaceListCollectionViewCell.swift
//  Offroad-iOS
//
//  Created by 김민성 on 8/3/24.
//

import UIKit

class PlaceCollectionViewCell: ShrinkableCollectionViewCell {
    
    //MARK: - Properties
    
    private let collectionViewHorizontalSectionInset: CGFloat = 24
    private lazy var widthConstraint = contentView.widthAnchor.constraint(
        equalToConstant: UIScreen.current.bounds.width - collectionViewHorizontalSectionInset * 2
    )
    private lazy var expandedBottomConstraint = placeDescriptionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -18)
    private lazy var shrinkedBottomConstraint = addressLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -18)
    
    private lazy var descriptionLabelTrailingConstraintToSeparator = placeDescriptionLabel.trailingAnchor.constraint(
        equalTo: placeDesctiprionSeparator.leadingAnchor,
        constant: -10
    )
    private lazy var descriptionLabelTrailingConstraintToSuperView = placeDescriptionLabel.trailingAnchor.constraint(
        equalTo: placeDescriptionView.trailingAnchor,
        constant: -12
    )
    
    override var isSelected: Bool {
        didSet { setAppearance() }
    }
    
    //MARK: - UI Properties
    
    let placeCategoryView = UIView()
    let placeCategoryLabel = UILabel()
    let placeSectionView = UIView()
    let placeSectionLabel = UILabel()
    
    let placeNameLabel = UILabel()
    let addressLabel = UILabel()
    
    let placeDescriptionView = UIView()
    let placeDescriptionImageView = UIImageView()
    let placeDescriptionLabel = UILabel()
    let placeDesctiprionSeparator = UIView()
    let visitCountLabel = UILabel()
    
    let chevronImageView = UIImageView(image: .icnPlaceListExpendableCellChevron)
    
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
        
        placeCategoryLabel.text = ""
        placeSectionLabel.text = ""
        placeNameLabel.text = ""
        addressLabel.text = ""
        placeDescriptionImageView.image = nil
        placeDescriptionLabel.text = ""
        visitCountLabel.text = ""
    }
    
}

extension PlaceCollectionViewCell {
    
    //MARK: - Private Func
    
    private func setupHierarchy() {
        contentView.addSubviews(
            placeCategoryView,
            placeSectionView,
            placeNameLabel,
            addressLabel,
            chevronImageView,
            placeDescriptionView
        )
        
        placeCategoryView.addSubview(placeCategoryLabel)
        placeSectionView.addSubview(placeSectionLabel)
        
        placeDescriptionView.addSubviews(
            placeDescriptionImageView,
            placeDescriptionLabel,
            placeDesctiprionSeparator,
            visitCountLabel
        )
    }
    
    private func setupStyle() {
        contentView.backgroundColor = .main(.main3)
        contentView.roundCorners(cornerRadius: 5)
        
        placeCategoryView.do { view in
            view.backgroundColor = .neutral(.nametagInactive)
            view.roundCorners(cornerRadius: 13)
        }
        
        placeCategoryLabel.do { label in
            label.textAlignment = .center
            label.font = .offroad(style: .iosTextContentsSmall)
            label.textColor = .sub(.sub2)
        }
        
        placeSectionView.do { view in
            view.backgroundColor = .primary(.characterSelectBg1)
            view.roundCorners(cornerRadius: 13)
        }
        
        placeSectionLabel.do { label in
            label.textAlignment = .center
            label.font = .offroad(style: .iosTextContentsSmall)
            label.textColor = .sub(.sub)
        }
        
        placeNameLabel.do { label in
            label.font = .offroad(style: .iosTooltipTitle)
            label.textColor = .main(.main2)
            label.textAlignment = .left
            label.numberOfLines = 1
            //label.adjustsFontSizeToFitWidth = true
        }
        
        addressLabel.do { label in
            label.font = .offroad(style: .iosHint)
            // 추후 ColorLiteral로 변경 가능성 있음.
            label.textColor = .init(hexCode: "717171")
            label.textAlignment = .left
            label.numberOfLines = 0
        }
        
        chevronImageView.do { imageView in
            imageView.contentMode = .scaleAspectFit
        }
        
        placeDescriptionView.do { view in
            view.backgroundColor = .primary(.boxInfo)
            view.roundCorners(cornerRadius: 9)
        }
        
        placeDescriptionImageView.do { imageView in
            imageView.contentMode = .scaleAspectFit
        }
        
        placeDescriptionLabel.do { label in
            label.font = .offroad(style: .iosTextContents)
            label.textColor = .main(.main2)
            label.textAlignment = .left
            label.lineBreakStrategy = .hangulWordPriority
            label.numberOfLines = 0
        }
        
        placeDesctiprionSeparator.do { view in
            view.backgroundColor = .primary(.characterSelectBg1)
        }
        
        visitCountLabel.do { label in
            label.font = .offroad(style: .iosTooltipNumber)
            label.textColor = .sub(.sub2)
            label.textAlignment = .left
        }
    }
    
    private func setupLayout() {
        widthConstraint.priority = .defaultHigh
        widthConstraint.isActive = true
        
        placeCategoryLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(10)
        }
        
        placeCategoryView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(18)
            make.leading.equalToSuperview().inset(20)
            make.width.greaterThanOrEqualTo(30)
            make.height.equalTo(27)
        }
        
        placeSectionLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(10)
        }
        
        placeSectionView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(18)
            make.leading.equalTo(placeCategoryView.snp.trailing).offset(6)
            make.width.greaterThanOrEqualTo(30)
            make.height.equalTo(27)
        }
        
        placeNameLabel.snp.makeConstraints { make in
            make.top.equalTo(placeCategoryView.snp.bottom).offset(14)
            make.leading.equalToSuperview().inset(20)
            make.trailing.equalTo(chevronImageView.snp.leading).offset(-17)
        }
        
        addressLabel.snp.makeConstraints { make in
            make.top.equalTo(placeNameLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(placeNameLabel)
            
        }
        
        chevronImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(37)
            make.trailing.equalToSuperview().inset(4)
            make.size.equalTo(44)
        }
        
        placeDescriptionImageView.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(12)
            make.centerY.equalToSuperview()
            make.width.equalTo(23)
        }
        
        placeDescriptionLabel.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(9)
            make.leading.equalTo(placeDescriptionImageView.snp.trailing).offset(6)
        }
        placeDescriptionLabel.setContentHuggingPriority(.init(1), for: .horizontal)
        
        placeDesctiprionSeparator.snp.makeConstraints { make in
            make.leading.greaterThanOrEqualTo(placeDescriptionLabel.snp.trailing).offset(10)
            make.width.equalTo(1)
            make.verticalEdges.equalToSuperview().inset(7)
        }
        
        visitCountLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(placeDesctiprionSeparator.snp.trailing).offset(9)
            make.trailing.equalToSuperview().inset(13)
        }
        visitCountLabel.setContentCompressionResistancePriority(.init(1000), for: .horizontal)
        
        placeDescriptionView.snp.makeConstraints { make in
            make.top.equalTo(addressLabel.snp.bottom).offset(14)
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        expandedBottomConstraint.priority = .defaultLow
        shrinkedBottomConstraint.priority = .defaultLow
        
        expandedBottomConstraint.isActive = isSelected
        shrinkedBottomConstraint.isActive = !isSelected
        placeDescriptionView.isHidden = !isSelected
    }
    
    private func setAppearance() {
        placeDescriptionView.isHidden = !isSelected
        expandedBottomConstraint.isActive = isSelected
        shrinkedBottomConstraint.isActive = !isSelected
        
        let rotationTransform = isSelected ? CGAffineTransform(rotationAngle: .pi * 0.999) : CGAffineTransform.identity
        chevronImageView.transform = rotationTransform
        contentView.layoutIfNeeded()
    }
    
    //MARK: - Func
    
    func configureCell(with place: some PlaceDescribable, showingVisitingCount: Bool) {
        placeSectionLabel.text = place.placeArea
        placeNameLabel.text = place.name
        addressLabel.text = place.address
        placeDescriptionLabel.text = place.shortIntroduction
        
        visitCountLabel.text = "탐험횟수: \(place.visitCount)"
        
        placeDesctiprionSeparator.isHidden = !showingVisitingCount
        visitCountLabel.isHidden = !showingVisitingCount
        
        descriptionLabelTrailingConstraintToSeparator.isActive = showingVisitingCount
        descriptionLabelTrailingConstraintToSuperView.isActive = !showingVisitingCount
        
        switch place.placeCategory {
        case .cafe:
            placeCategoryLabel.text = "카페"
            placeDescriptionImageView.image = .imgCategoryCafe
        case .restaurant:
            placeCategoryLabel.text = "식당"
            placeDescriptionImageView.image = .imgCategoryRestaurant
        case .park:
            placeCategoryLabel.text = "공원"
            placeDescriptionImageView.image = .imgCategoryPark
        case .sport:
            placeCategoryLabel.text = "스포츠"
            placeDescriptionImageView.image = .imgCategorySports
        case .culture:
            placeCategoryLabel.text = "문화"
            placeDescriptionImageView.image = .imgCategoryCulture
        }
        
        contentView.layoutIfNeeded()
    }
    
}
