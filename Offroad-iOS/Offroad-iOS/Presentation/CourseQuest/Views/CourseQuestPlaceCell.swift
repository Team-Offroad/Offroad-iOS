//
//  CourseQuestPlaceCell.swift
//  Offroad-iOS
//
//  Created by  정지원 on 5/13/25.
//
import UIKit

import SnapKit
import Then
import Kingfisher
import SVGKit

class CourseQuestPlaceCell: UICollectionViewCell, SVGFetchable {
    
    // MARK: - UI Components
    
    private let indicatorImageView = UIImageView()
    private let containerView = UIView()
    
    private var thumbnailImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.roundCorners(cornerRadius: 5)
    }
    
    private let typeLabelView = UIImageView().then {
        $0.image = .icnPurpleCategory
    }
    
    private let typeLabel = UILabel().then {
        $0.font = .offroad(style: .iosTextContentsSmall)
        $0.textColor = .sub(.sub2)
        $0.numberOfLines = 1
    }
    
    private let nameLabel = UILabel().then {
        $0.font = .offroad(style: .iosTextBold)
        $0.textColor = .main(.main2)
    }
    
    private let addressLabel = UILabel().then {
        $0.font = .offroad(style: .iosTextContentsSmall)
        $0.textColor = .grayscale(.gray400)
        $0.numberOfLines = 1
    }
    
    private let visitButton = UIButton().then {
        $0.setTitle("방문", for: .normal)
        $0.setTitleColor(.sub(.sub), for: .normal)
        $0.titleLabel?.font = .offroad(style: .iosBtnSmall)
        $0.backgroundColor = .primary(.boxInfo)
        $0.layer.cornerRadius = 5
    }
    
    private let clearImageView = UIImageView().then {
        $0.image = UIImage(resource: .icnClearStamp)
        $0.isHidden = true
    }
    
    var onVisit: (() -> Void)?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupHierarchy()
        setupStyle()
        setupLayout()
        visitButton.addTarget(self, action: #selector(visitTapped), for: .touchUpInside)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupStyle() {
        backgroundColor = .clear
        contentView.backgroundColor = .clear
        containerView.backgroundColor = .white
        containerView.roundCorners(cornerRadius: 5)
        containerView.clipsToBounds = true
    }
    
    private func setupHierarchy() {
        contentView.addSubviews(indicatorImageView, containerView)
        containerView.addSubviews(
            thumbnailImageView,
            typeLabelView,
            nameLabel,
            visitButton,
            clearImageView,
            addressLabel
        )
        typeLabelView.addSubview(typeLabel)
    }
    
    private func setupLayout() {
        indicatorImageView.snp.makeConstraints {
            $0.left.equalToSuperview()
            $0.centerY.equalToSuperview()
        }
        
        containerView.snp.makeConstraints {
            $0.leading.equalTo(indicatorImageView.snp.trailing).offset(12)
            $0.trailing.equalToSuperview()
            $0.verticalEdges.equalToSuperview()
            $0.height.equalTo(97)
        }
        
        thumbnailImageView.snp.makeConstraints {
            $0.leading.equalToSuperview().inset(14)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(72)
        }
        
        typeLabelView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(13.25)
            $0.leading.equalTo(thumbnailImageView.snp.trailing).offset(12)
            $0.width.equalTo(41)
            $0.height.equalTo(20)
        }
        
        typeLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(typeLabelView.snp.bottom).offset(6)
            $0.leading.equalTo(thumbnailImageView.snp.trailing).offset(12)
            $0.trailing.lessThanOrEqualToSuperview().inset(75)
        }
        
        addressLabel.snp.makeConstraints {
            $0.top.equalTo(visitButton.snp.bottom).offset(5.2)
            $0.leading.equalTo(thumbnailImageView.snp.trailing).offset(12)
            $0.trailing.lessThanOrEqualToSuperview().inset(14)
            $0.bottom.lessThanOrEqualToSuperview().inset(12.8)
        }
        
        visitButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(15)
            $0.centerY.equalTo(nameLabel)
            $0.width.equalTo(56)
            $0.height.equalTo(28)
        }
        
        clearImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(6)
            $0.centerY.equalToSuperview()
        }
    }
    
    func configure(with model: CourseQuestDetailPlaceDTO) {
//        if model.categoryImage.lowercased().hasSuffix(".svg") { thumbnailImageView.fetchSvgURLToImageView(svgUrlString: model.categoryImage) } else { thumbnailImageView.kf.setImage(with: URL(string: model.categoryImage)) }
        thumbnailImageView.fetchSvgURLToImageView(svgUrlString: model.categoryImage)
        typeLabel.text = model.category
        nameLabel.text = model.name
        addressLabel.text = model.address
        
        // 방문 여부에 따라 버튼 or 스탬프 표시
        visitButton.isHidden = model.isVisited ?? false
        clearImageView.isHidden = !(model.isVisited ?? false)
        
        // 타입에 따라 indicator 색상 변경
        switch model.category {
        case "카페": indicatorImageView.image = UIImage(resource: .icnYellowIndicator)
        case "공원": indicatorImageView.image = UIImage(resource: .icnGreenIndicator)
        case "식당": indicatorImageView.image = UIImage(resource: .icnOrangeIndicator)
        case "문화": indicatorImageView.image = UIImage(resource: .icnPinkIndicator)
        case "스포츠": indicatorImageView.image = UIImage(resource: .icnBlueIndicator)
        default: indicatorImageView.image = UIImage(resource: .icnOrangeIndicator)
        }
    }
    
    @objc private func visitTapped() {
        onVisit?()
    }
}
