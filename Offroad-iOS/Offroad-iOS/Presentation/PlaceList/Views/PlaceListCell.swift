//
//  PlaceListCell.swift
//  Offroad-iOS
//
//  Created by 김민성 on 4/20/25.
//

import UIKit

import ExpandableCell
import SnapKit
import Then

final class PlaceListCell: ExpandableCell, Shrinkable {
    
    var shrinkingAnimator: UIViewPropertyAnimator = UIViewPropertyAnimator(duration: 0.4, dampingRatio: 1)
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                shrink(scale: 0.97)
            } else {
                restore()
            }
        }
    }
    
    // images
    private let cafeImage: UIImage = .imgCategoryCafe
    private let restaurantImage: UIImage = .imgCategoryRestaurant
    private let parkImage: UIImage = .imgCategoryPark
    private let sportsImage: UIImage = .imgCategorySports
    private let cultureImage: UIImage = .imgCategoryCulture
    
    // MARK: - UI Properties
    
    private let categoryLabel = PlaceListCellCategoryLabel()
    private let placeAreaLabel = PlaceListCellCategoryLabel()
    private lazy var categoryStack = UIStackView(arrangedSubviews: [categoryLabel, placeAreaLabel])
    
    private let placeNameLabel = UILabel()
    private let addressLabel = UILabel()
    private lazy var nameAddressStack = UIStackView(arrangedSubviews: [placeNameLabel, addressLabel])
    private let chevronImageView = UIImageView(image: .icnPlaceListExpendableCellChevron)
    
    // 탐험횟수를 표시하지 않는 경우 - 뒤에 1 붙는 뷰들
    private let descriptionViewWithoutVisitCount = UIView()
    private let categoryImageView1 = UIImageView()
    private let descriptionLabel1 = UILabel()
    private lazy var descriptionStack1 = UIStackView(
        arrangedSubviews: [categoryImageView1, descriptionLabel1]
    )
    
    // 탐험횟수를 표시하는 경우 - 뒤에 2 붙는 뷰들
    private let descriptionViewIncludingVisitCount = UIView()
    private let categoryImageView2 = UIImageView()
    private let descriptionLabel2 = UILabel()
    private let separator = UIView()
    private let visitCountLabel = UILabel()
    private lazy var descriptionStack2 = UIStackView(
        arrangedSubviews: [categoryImageView2, descriptionLabel2]
    )
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
    }
    
    @MainActor required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        categoryLabel.text = ""
        placeAreaLabel.text = ""
        placeNameLabel.text = ""
        addressLabel.text = ""
        categoryImageView1.image = nil
        categoryImageView2.image = nil
        descriptionLabel1.text = ""
        descriptionLabel2.text = ""
        visitCountLabel.text = "탐험횟수: "
    }
    
    override func animateExpansion() {
        chevronImageView.transform = .init(rotationAngle: .pi * 0.999)
        descriptionViewWithoutVisitCount.alpha = 1
        descriptionViewIncludingVisitCount.alpha = 1
    }
    
    override func animateCollapse() {
        chevronImageView.transform = .identity
        descriptionViewWithoutVisitCount.alpha = 0
        descriptionViewIncludingVisitCount.alpha = 0
    }
    
}


private extension PlaceListCell {
    
    private func setupStyle() {
        contentView.backgroundColor = .main(.main3)
        contentView.roundCorners(cornerRadius: 5)
        
        categoryLabel.do { label in
            label.textAlignment = .center
            label.font = .offroad(style: .iosTextContentsSmall)
            label.textColor = .sub(.sub2)
            label.backgroundColor = .neutral(.nametagInactive)
            label.roundCorners(cornerRadius: 13)
            label.numberOfLines = 1
            label.layoutMargins = .init(top: 0, left: 10, bottom: 0, right: 10)
        }
        
        placeAreaLabel.do { label in
            label.textAlignment = .center
            label.font = .offroad(style: .iosTextContentsSmall)
            label.textColor = .sub(.sub)
            label.backgroundColor = .primary(.characterSelectBg1)
            label.roundCorners(cornerRadius: 13)
            label.numberOfLines = 1
            label.layoutMargins = .init(top: 0, left: 10, bottom: 0, right: 10)
        }
        
        categoryStack.do { stackView in
            stackView.axis = .horizontal
            stackView.spacing = 6
            stackView.alignment = .fill
            stackView.distribution = .fillProportionally
        }
        
        placeNameLabel.do { label in
            label.font = .offroad(style: .iosTooltipTitle)
            label.textColor = .main(.main2)
            label.textAlignment = .left
            label.numberOfLines = 0
        }
        
        addressLabel.do { label in
            label.font = .offroad(style: .iosHint)
            label.textColor = .grayscale(.gray400)
            label.textAlignment = .left
            label.numberOfLines = 0
        }
        
        nameAddressStack.do { stackView in
            stackView.axis = .vertical
            stackView.spacing = 12
            stackView.alignment = .leading
            stackView.distribution = .fillProportionally
        }
        
        // 탐험횟수 없는 경우
        
        descriptionViewWithoutVisitCount.do { view in
            view.backgroundColor = .primary(.boxInfo)
            view.roundCorners(cornerRadius: 9)
        }
        
        categoryImageView1.contentMode = .scaleAspectFit
        
        descriptionLabel1.do { label in
            label.font = .offroad(style: .iosTextContents)
            label.textColor = .main(.main2)
            label.textAlignment = .left
            label.lineBreakStrategy = .hangulWordPriority
            label.numberOfLines = 0
        }
        
        descriptionStack1.do { stackView in
            stackView.axis = .horizontal
            stackView.spacing = 6
            stackView.alignment = .fill
            stackView.distribution = .fill
        }
        
        // 탐험 횟수 있는 경우
        
        descriptionViewIncludingVisitCount.do { view in
            view.backgroundColor = .primary(.boxInfo)
            view.roundCorners(cornerRadius: 9)
        }
        
        categoryImageView2.contentMode = .scaleAspectFit
        
        descriptionLabel2.do { label in
            label.font = .offroad(style: .iosTextContents)
            label.textColor = .main(.main2)
            label.textAlignment = .left
            label.lineBreakStrategy = .hangulWordPriority
            label.numberOfLines = 0
        }
        
        descriptionStack2.do { stackView in
            stackView.axis = .horizontal
            stackView.spacing = 6
            stackView.alignment = .fill
            stackView.distribution = .fill
        }
        
        separator.backgroundColor = .primary(.characterSelectBg1)
        
        visitCountLabel.do { label in
            label.font = .offroad(style: .iosTooltipNumber)
            label.textColor = .sub(.sub2)
            label.textAlignment = .left
        }
        
    }
    
    private func setupHierarchy() {
        mainContentView.addSubviews(
            categoryStack,
            nameAddressStack,
            chevronImageView
        )
        
        detailContentView.addSubviews(
            descriptionViewWithoutVisitCount,
            descriptionViewIncludingVisitCount
        )
        
        descriptionViewWithoutVisitCount.addSubview(descriptionStack1)
        descriptionViewIncludingVisitCount.addSubviews(descriptionStack2, separator, visitCountLabel)
    }
    
    private func setupLayout() {
        categoryStack.setContentHuggingPriority(.defaultHigh + 1, for: .vertical)
        categoryStack.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(18)
            make.leading.equalToSuperview().inset(20)
            make.trailing.lessThanOrEqualTo(chevronImageView.snp.leading).priority(.init(997))
        }
        
        placeNameLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        addressLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        nameAddressStack.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        nameAddressStack.snp.makeConstraints { make in
            make.top.equalTo(categoryStack.snp.bottom).offset(14)
            make.leading.equalTo(20)
            make.trailing.lessThanOrEqualTo(chevronImageView.snp.leading)
            make.bottom.equalToSuperview().inset(18)
        }
        
        chevronImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(4)
            make.size.equalTo(44)
        }
        
        [categoryImageView1, categoryImageView2].forEach { imageView in
            imageView.setContentHuggingPriority(.defaultLow, for: .horizontal)
            imageView.snp.makeConstraints { make in
                make.width.equalTo(22)
            }
        }
        
        descriptionStack1.setContentHuggingPriority(.defaultLow, for: .horizontal)
        descriptionStack1.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(9)
            make.horizontalEdges.equalToSuperview().inset(12)
        }
        
        descriptionLabel2.setContentCompressionResistancePriority(.defaultHigh, for: .horizontal)
        
        descriptionStack2.setContentHuggingPriority(.defaultLow - 1, for: .horizontal)
        descriptionStack2.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(9)
            make.leading.equalToSuperview().inset(12)
            make.trailing.equalTo(separator.snp.leading).offset(-10)
        }
        
        [descriptionLabel1, descriptionLabel2].forEach { label in
            label.setContentHuggingPriority(.defaultLow-1, for: .horizontal)
        }
        
        separator.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(7)
            make.width.equalTo(1)
        }
        
        visitCountLabel.setContentCompressionResistancePriority(.defaultHigh + 2, for: .horizontal)
        visitCountLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(separator.snp.trailing).offset(14)
            make.trailing.equalToSuperview().inset(17)
        }
        
    }
    
}

extension PlaceListCell {
    
    func configure(with model: PlaceModel, isVisitCountShowing: Bool) {
        switch model.placeCategory {
        case .cafe:
            categoryLabel.text = "카페"
            categoryImageView1.image = cafeImage
            categoryImageView2.image = cafeImage
        case .restaurant:
            categoryLabel.text = "식당"
            categoryImageView1.image = restaurantImage
            categoryImageView2.image = restaurantImage
        case .park:
            categoryLabel.text = "공원"
            categoryImageView1.image = parkImage
            categoryImageView2.image = parkImage
        case .sport:
            categoryLabel.text = "스포츠"
            categoryImageView1.image = sportsImage
            categoryImageView2.image = sportsImage
        case .culture:
            categoryLabel.text = "문화"
            categoryImageView1.image = cultureImage
            categoryImageView2.image = cultureImage
        }
        placeAreaLabel.text = model.placeArea
        placeNameLabel.text = model.name
        addressLabel.text = model.address
        descriptionLabel1.text = model.shorIntroduction
        descriptionLabel2.text = model.shorIntroduction
        visitCountLabel.text = "탐험횟수: \(model.visitCount)"
        
        if isVisitCountShowing {
            descriptionViewWithoutVisitCount.removeFromSuperview()
            descriptionViewWithoutVisitCount.snp.removeConstraints()
            detailContentView.addSubview(descriptionViewIncludingVisitCount)
            descriptionViewIncludingVisitCount.snp.makeConstraints { make in
                make.top.equalToSuperview().priority(.high)
                make.horizontalEdges.equalToSuperview().inset(20).priority(.init(999))
                make.bottom.equalToSuperview().inset(18).priority(.init(999))
            }
        } else {
            descriptionViewIncludingVisitCount.removeFromSuperview()
            descriptionViewIncludingVisitCount.snp.removeConstraints()
            detailContentView.addSubview(descriptionViewWithoutVisitCount)
            descriptionViewWithoutVisitCount.snp.makeConstraints { make in
                make.top.equalToSuperview().priority(.high.advanced(by: 20))
                make.horizontalEdges.equalToSuperview().inset(20)
                make.bottom.equalToSuperview().inset(18)
            }
        }
        
        contentView.layoutSubviews()
    }
    
}

final class PlaceListCellCategoryLabel: UILabel {
    
    private let inset: UIEdgeInsets = .init(top: 6.5, left: 10, bottom: 6.5, right: 10)
    
    override func draw(_ rect: CGRect) {
        super.drawText(in: rect.inset(by: inset))
    }
    
    override var intrinsicContentSize: CGSize {
        var contentSize = super.intrinsicContentSize
        contentSize.height += (inset.top + inset.bottom)
        contentSize.width += (inset.left + inset.right)
        return contentSize
    }
    
}
