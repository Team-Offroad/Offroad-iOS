//
//  CourseQuestPlaceCell.swift
//  Offroad-iOS
//
//  Created by  정지원 on 5/13/25.
//
import UIKit

import SnapKit
import Then

class CourseQuestPlaceCell: UICollectionViewCell {
    
    // MARK: - UI Components
    
    private let indicatorImageView = UIImageView()
    private let containerView = UIView()
    
    private let thumbnailImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFill
        $0.roundCorners(cornerRadius: 5)
        $0.clipsToBounds = true
    }
    
    private let typeLabelView = UIView().then {
        $0.backgroundColor = UIColor.neutral(.nametagInactive)
        $0.roundCorners(cornerRadius: 14)
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
            $0.size.equalTo(24)
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
        }
        
        typeLabel.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview().inset(5)
            $0.horizontalEdges.equalToSuperview().inset(10)
        }
        
        nameLabel.snp.makeConstraints {
            $0.top.equalTo(typeLabelView.snp.bottom).offset(4)
            $0.leading.equalTo(thumbnailImageView.snp.trailing).offset(12)
        }
        
        addressLabel.snp.makeConstraints {
            $0.top.equalTo(nameLabel.snp.bottom).offset(7)
            $0.leading.equalTo(thumbnailImageView.snp.trailing).offset(12)
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
    
    func configure(with model: CourseQuestPlace) {
        thumbnailImageView.image = UIImage(named: model.imageName)
        typeLabel.text = " \(model.type) "
        nameLabel.text = model.name
        addressLabel.text = model.address
        
        // 방문 여부에 따라 버튼 or 스탬프 표시
        visitButton.isHidden = model.isVisited
        clearImageView.isHidden = !model.isVisited
        
        // 타입에 따라 indicator 색상 변경
        switch model.type {
        case "카페": indicatorImageView.image = UIImage(resource: .icnOrangeIndicator)
        case "공원": indicatorImageView.image = UIImage(resource: .icnBlueIndicator)
        case "식당": indicatorImageView.image = UIImage(resource: .icnPinkIndicator)
        default: indicatorImageView.image = UIImage(resource: .icnOrangeIndicator)
        }
    }
    
    @objc private func visitTapped() {
        onVisit?()
    }
}
