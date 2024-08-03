//
//  PlaceListCollectionViewCell.swift
//  Offroad-iOS
//
//  Created by 김민성 on 8/3/24.
//

import UIKit

class PlaceListCollectionViewCell: UICollectionViewCell {
    
    let placeNameLabel = UILabel()
    let addressLabel = UILabel()
    let placeDescriptionView = UIView()
    let placeDescriptionImageView = UIImageView()
    let placeDescriptionLabel = UILabel()
    let placeDesctiprionSeparator = UIView()
    let visitCountLabel = UILabel()
    
    // 현재는 SFSymbol로 해 놓은 상태. 추후 피그마에 있는 아이콘으로 변경할 예정
    let chevronImageView = UIImageView(image: .icnPlaceListExpendableCellChevron)
    
    let chevronAnimator = UIViewPropertyAnimator(duration: 0.3, dampingRatio: 1)
    
    lazy var widthConstraint = contentView.widthAnchor.constraint(equalToConstant: UIScreen.current.bounds.width - 32)
    lazy var expandedBottomConstraint = placeDescriptionView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -18)
    lazy var shrinkedBottomConstraint = addressLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -18)
    
    override var isSelected: Bool {
        didSet {
            setAppearance()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupHierarchy()
        setupStyle()
        setupLayout(isExpanded: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PlaceListCollectionViewCell {
    
    private func setupHierarchy() {
        contentView.addSubviews(
            placeNameLabel,
            addressLabel,
            chevronImageView,
            placeDescriptionView
        )
        
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
        contentView.layer.borderColor = UIColor.clear.cgColor
        
        placeNameLabel.do { label in
            label.font = .offroad(style: .iosTooltipTitle)
            label.textColor = .main(.main2)
            label.textAlignment = .left
            label.numberOfLines = 1
            label.adjustsFontSizeToFitWidth = true
        }
        
        addressLabel.do { label in
            label.font = .offroad(style: .iosHint)
            // 추후 ColorLiteral로 변경 요망
            label.textColor = .init(hexCode: "717171")
            label.textAlignment = .left
            label.numberOfLines = 0
        }
        
        chevronImageView.do { imageView in
            imageView.contentMode = .scaleAspectFit
        }
        
        placeDescriptionView.do { view in
            // 추후 ColorLiteral로 변경 요망
            view.backgroundColor = .init(hexCode: "FFF5EA")
            view.roundCorners(cornerRadius: 9)
        }
        
        placeDescriptionImageView.do { imageView in
            imageView.contentMode = .scaleAspectFit
        }
        
        placeDescriptionLabel.do { label in
            label.font = .offroad(style: .iosTextContents)
            label.textColor = .main(.main2)
            label.textAlignment = .left
        }
        
        placeDesctiprionSeparator.do { view in
            view.backgroundColor = .primary(.characterSelectBg3)
        }
        
        visitCountLabel.do { label in
            label.font = .offroad(style: .iosTooltipNumber)
            label.textColor = .sub(.sub2)
            label.textAlignment = .left
        }
    }
    
    private func setupLayout(isExpanded: Bool) {
        widthConstraint.priority = UILayoutPriority(1000)
        widthConstraint.isActive = true
        
        placeNameLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(14)
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
            make.centerY.equalToSuperview()
            make.leading.equalTo(placeDescriptionImageView.snp.trailing).offset(6)
        }
        placeDescriptionLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        
        placeDesctiprionSeparator.snp.makeConstraints { make in
            make.leading.equalTo(placeDescriptionLabel.snp.trailing).offset(10)
            make.width.equalTo(1)
            make.verticalEdges.equalToSuperview().inset(7)
        }
        
        visitCountLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(placeDesctiprionSeparator.snp.trailing).offset(10)
            make.trailing.equalToSuperview().inset(13)
        }
        
        placeDescriptionView.snp.makeConstraints { make in
            make.top.equalTo(addressLabel.snp.bottom).offset(14)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(36)
        }
        
        expandedBottomConstraint.priority = .defaultLow
        shrinkedBottomConstraint.priority = .defaultLow
        
        expandedBottomConstraint.isActive = isExpanded
        shrinkedBottomConstraint.isActive = !isExpanded
        placeDescriptionView.isHidden = !isExpanded
    }
    
    private func setAppearance() {
        contentView.layer.borderWidth = isSelected ? 1 : 0
        expandedBottomConstraint.isActive = isSelected
        shrinkedBottomConstraint.isActive = !isSelected
        placeDescriptionView.isHidden = !isSelected
        
        chevronAnimator.stopAnimation(true)
        chevronAnimator.addAnimations { [weak self] in
            guard let self else { return }
            let rotationTransform = isSelected ? CGAffineTransform(rotationAngle: .pi * 0.999) : CGAffineTransform.identity
            chevronImageView.transform = rotationTransform
        }
        chevronAnimator.startAnimation()
        
        contentView.layoutIfNeeded()
    }
    
    func configureCell(with place: RegisteredPlaceInfo) {
        placeNameLabel.text = place.name
        addressLabel.text = place.address
        placeDescriptionLabel.text = place.shortIntroduction
        visitCountLabel.text = "탐험횟수: \(place.visitCount)"
    }
    
}
