//
//  placeInfoPopupView.swift
//  Offroad-iOS
//
//  Created by 김민성 on 2024/07/17.
//

import UIKit

class PlaceInfoPopupView: UIView {
    
    //MARK: - Properties
    
    //MARK: - UI Properties
    
    let popupView = UIView()
    
    private let tooptipImageView = UIImageView(image: .icnPlaceInfoPopupTooltip)
    private let rectView = UIView()
    private let offroadLogoImageView = UIImageView(image: .icnOffroadlogoPopupView)
    private let nameLabel = UILabel()
    private let nameAndImageStackView = UIStackView()
    
    private var placeCategoryImageView = UIImageView()
    private let shortDescriptionLabel = UILabel()
    private let addresssLabel = UILabel()
    private let visitCountLabel = UILabel()
    
    let exploreButton = UIButton()
    let closeButton = UIButton()
    
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
    
}

extension PlaceInfoPopupView {
    
    //MARK: - Layout
    
    private func setupHierarchy() {
        nameAndImageStackView.addArrangedSubviews(nameLabel, placeCategoryImageView)
        rectView.addSubviews(
            offroadLogoImageView,
            nameAndImageStackView,
            shortDescriptionLabel,
            addresssLabel,
            visitCountLabel,
            exploreButton,
            closeButton
        )
        popupView.addSubviews(
            tooptipImageView,
            rectView
        )
        
        addSubview(popupView)
    }
    
    private func setupLayout() {
        tooptipImageView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        rectView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().inset(15)
        }
        
        nameAndImageStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(17)
            make.leading.equalToSuperview().inset(15)
        }
        
        placeCategoryImageView.snp.makeConstraints { make in
            make.width.height.equalTo(21)
        }
        
        shortDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(nameAndImageStackView.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(15)
        }
        
        addresssLabel.snp.makeConstraints { make in
            make.top.equalTo(shortDescriptionLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview().inset(15)
        }
        
        visitCountLabel.snp.makeConstraints { make in
            make.top.equalTo(addresssLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().inset(15)
        }
        
        exploreButton.snp.makeConstraints { make in
            make.top.equalTo(visitCountLabel.snp.bottom).offset(15)
            make.horizontalEdges.equalToSuperview().inset(14)
            make.bottom.equalToSuperview().inset(14)
            make.height.equalTo(36)
        }
        
        closeButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview()
            make.width.height.equalTo(44)
        }
        
        popupView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalTo(245)
        }
    }
    
    //MARK: - Private Func
    
    private func setupStyle() {
        backgroundColor = .clear
        
        popupView.do { view in
            view.backgroundColor = .clear
            //view.roundCorners(cornerRadius: 10)
        }
        
        rectView.do { view in
            view.backgroundColor = .main(.main3)
            view.roundCorners(cornerRadius: 10)
        }
        
        offroadLogoImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview()
        }
        
        nameLabel.setContentCompressionResistancePriority(UILayoutPriority(1000), for: .horizontal)
        nameLabel.do { label in
            label.font = .offroad(style: .iosTooltipTitle)
            label.textColor = .main(.main2)
            label.textAlignment = .left
        }
        
        nameAndImageStackView.do { stackView in
            stackView.axis = .horizontal
            stackView.spacing = 5
            stackView.alignment = .center
            stackView.distribution = .fillProportionally
        }
        
        shortDescriptionLabel.do { label in
            label.font = .offroad(style: .iosTextContents)
            label.numberOfLines = 0
            label.lineBreakStrategy = .hangulWordPriority
            label.textColor = .main(.main2)
            label.textAlignment = .left
        }
        
        addresssLabel.do { label in
            label.font = .offroad(style: .iosTextContentsSmall)
            label.textColor = .grayscale(.gray400)
            label.numberOfLines = 2
            label.textAlignment = .left
        }
        
        visitCountLabel.do { label in
            label.font = .offroad(style: .iosTooltipNumber)
            label.textColor = .sub(.sub2)
            label.textAlignment = .left
        }
        
        exploreButton.do { button in
            button.setTitle("탐험하기", for: .normal)
            button.titleLabel?.font = .offroad(style: .iosBtnSmall)
            button.setTitleColor(.primary(.white), for: .normal)
            button.backgroundColor = .sub(.sub)
            button.roundCorners(cornerRadius: 5)
        }
        
        closeButton.do { button in
            button.setImage(.btnPlaceInfoPopupClose, for: .normal)
        }
    }
    
    //MARK: - Func
    
    func configurePopupView(with placeInfo: RegisteredPlaceInfo) {
        self.nameLabel.text = placeInfo.name
        self.shortDescriptionLabel.text = placeInfo.shortIntroduction
        self.addresssLabel.text = placeInfo.address
        self.visitCountLabel.text = "탐험횟수:\(placeInfo.visitCount)"
        guard let category = OffroadPlaceCategory(rawValue: placeInfo.placeCategory.lowercased()) else { return }
        switch category {
        case .caffe:
            placeCategoryImageView.image = .imgCategoryCafe //= UIImageView(image: .imgCategoryCafe)
        case .park:
            placeCategoryImageView.image = .imgCategoryPark //= UIImageView(image: .imgCategoryPark)
        case .restaurant:
            placeCategoryImageView.image = .imgCategoryRestaurant //= UIImageView(image: .imgCategoryRestaurant)
        case .culture:
            placeCategoryImageView.image = .imgCategoryCulture //= UIImageView(image: .imgCategoryCulture)
        case .sport:
            placeCategoryImageView.image = .imgCategorySports //= UIImageView(image: .imgCategorySports)
        case .none:
            placeCategoryImageView.image = nil //= UIImageView(image: .imgCategoryCafe)
        }
    }
}

