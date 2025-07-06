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

final class CourseQuestPlaceCell: UICollectionViewCell, SVGFetchable {
    
    // MARK: - UI Components
    
    private let indicatorImageView = UIImageView()
    private let containerView = UIView().then {
        $0.backgroundColor = .main(.main3)
        $0.roundCorners(cornerRadius: 5)
        $0.clipsToBounds = true
    }
    
    private var thumbnailImageView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.roundCorners(cornerRadius: 5)
    }
    
    private let typeLabelView = UIView().then {
        $0.roundCorners(cornerRadius: 10)
        $0.backgroundColor = .neutral(.nametagInactive)
    }
    
    private let typeLabel = UILabel().then {
        $0.font = .offroad(style: .iosTextContentsSmall)
        $0.textColor = .sub(.sub2)
        $0.numberOfLines = 1
    }
    
    private let nameLabel = UILabel().then {
        $0.font = .offroad(style: .iosTextBold)
        $0.textColor = .main(.main2)
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
    }
    
    private let addressLabel = UILabel().then {
        $0.font = .offroad(style: .iosTextContentsSmall)
        $0.textColor = .grayscale(.gray400)
        $0.numberOfLines = 0
        $0.lineBreakMode = .byWordWrapping
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
            $0.leading.equalToSuperview()
            $0.centerY.equalTo(containerView)
            $0.size.equalTo(34)
        }
        
        containerView.snp.makeConstraints {
            $0.top.equalToSuperview()
            $0.leading.equalTo(indicatorImageView.snp.trailing).offset(12)
            $0.trailing.equalToSuperview()
            $0.bottom.equalToSuperview()
            $0.width.equalTo(UIScreen.main.bounds.width - 94)
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
            $0.top.equalTo(nameLabel.snp.bottom).offset(7)
            $0.leading.equalTo(thumbnailImageView.snp.trailing).offset(12)
            $0.trailing.lessThanOrEqualToSuperview().inset(14)
            $0.bottom.equalToSuperview().inset(12.8)
        }
        
        visitButton.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(14.7)
            $0.centerY.equalToSuperview()
            $0.width.equalTo(56)
            $0.height.equalTo(28)
        }
        
        clearImageView.snp.makeConstraints {
            $0.trailing.equalToSuperview().inset(6)
            $0.centerY.equalToSuperview()
            $0.size.equalTo(75)
        }
    }
    
    ///참고: thumbnailImageView가 현재 URL이 아닌 svg 아이콘 파일로 서버에서 내려주고 있습니다.
    /// 장소 정보 모델을 기반으로 셀의 내용을 설정하는 함수
    /// - 썸네일 이미지, 카테고리 라벨, 장소명, 주소 등을 표시
    /// - 방문 여부에 따라 '방문' 버튼 또는 스탬프를 보여줌
    /// - 카테고리에 따라 인디케이터 색상을 설정
    func configure(with model: CourseQuestDetailPlaceDTO) {
        thumbnailImageView.fetchSvgURLToImageView(svgUrlString: model.categoryImage)
        typeLabel.text = model.category
        nameLabel.text = model.name
        addressLabel.text = model.address
        
        //        visitButton.isHidden = model.isVisited ?? false
        //        clearImageView.isHidden = !(model.isVisited ?? false)
        let isVisited = model.isVisited == true
        
        visitButton.alpha = isVisited ? 0 : 1
        visitButton.isUserInteractionEnabled = !isVisited
        
        clearImageView.alpha = isVisited ? 1 : 0
        clearImageView.isHidden = !isVisited
        
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
