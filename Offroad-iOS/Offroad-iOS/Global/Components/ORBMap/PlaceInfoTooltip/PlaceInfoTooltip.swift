//
//  PlaceInfoTooltip.swift
//  Offroad-iOS
//
//  Created by 김민성 on 10/27/24.
//

import UIKit

import NMapsMap

final class PlaceInfoTooltip: UIView {
    
    //MARK: - UI Properties
    
    // 카테고리 이미지들
    private let cafeImage = UIImage.imgCategoryCafe
    private let parkImage = UIImage.imgCategoryPark
    private let restaurantImage = UIImage.imgCategoryRestaurant
    private let cultureImage = UIImage.imgCategoryCulture
    private let sportsImage = UIImage.imgCategorySports
    
    private let tooltipImageView = UIImageView(image: .icnPlaceInfoPopupTooltip)
    private let rectView = UIView()
    private let offroadLogoImageView = UIImageView(image: .icnPlaceInfoTooltipOrbLogo)
    private let nameLabel = UILabel()
    private let placeCategoryImageView = UIImageView()
    private lazy var nameAndImageStackView = UIStackView(arrangedSubviews: [nameLabel, placeCategoryImageView])
    private let shortDescriptionLabel = UILabel()
    private let addressLabel = UILabel()
    private let visitCountLabel = UILabel()
    
    private(set) var marker: ORBNMFMarker? = nil {
        didSet {
            nameLabel.text = marker?.placeInfo.name ?? ""
            shortDescriptionLabel.text = marker?.placeInfo.shortIntroduction ?? ""
            addressLabel.text = marker?.placeInfo.address ?? ""
            visitCountLabel.text = "탐험횟수: \(marker?.placeInfo.visitCount ?? 0)"
            exploreButton.isEnabled = marker != nil
            // 카테고리 이미지 할당
            let categoryImage: UIImage? = {
                guard let marker, let category = ORBPlaceCategory(
                    rawValue: marker.placeInfo.placeCategory.lowercased()
                ) else {
                    return nil
                }
                
                switch category {
                case .caffe: return cafeImage
                case .park: return parkImage
                case .restaurant: return restaurantImage
                case .culture: return cultureImage
                case .sport: return sportsImage
                default: return nil
                }
            }()
            placeCategoryImageView.image = categoryImage
        }
    }
    
    let exploreButton = ShrinkableButton(shrinkScale: 0.97)
    let closeButton = UIButton()
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PlaceInfoTooltip  {
    
    //MARK: - Layout Func
    
    private func setupLayout() {
        tooltipImageView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.centerX.equalToSuperview()
        }
        
        rectView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview().inset(15)
        }
        
        offroadLogoImageView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(27)
            make.trailing.equalToSuperview().inset(22)
            make.bottom.equalTo(exploreButton.snp.top).offset(-6)
        }
        
        nameAndImageStackView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(17)
            make.leading.equalToSuperview().inset(15)
            make.trailing.lessThanOrEqualTo(closeButton.snp.leading).offset(-3)
        }
        
        placeCategoryImageView.snp.makeConstraints { make in
            make.width.height.equalTo(21)
        }
        
        shortDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(nameAndImageStackView.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview().inset(15)
        }
        
        addressLabel.snp.makeConstraints { make in
            make.top.equalTo(shortDescriptionLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalToSuperview().inset(15)
        }
        
        visitCountLabel.snp.makeConstraints { make in
            make.top.equalTo(addressLabel.snp.bottom).offset(10)
            make.leading.equalToSuperview().inset(15)
        }
        
        exploreButton.snp.makeConstraints { make in
            make.top.equalTo(visitCountLabel.snp.bottom).offset(15)
            make.horizontalEdges.equalToSuperview().inset(14)
            make.bottom.equalToSuperview().inset(14)
            make.height.equalTo(36)
        }
        
        closeButton.snp.makeConstraints { make in
            make.centerX.equalTo(rectView.snp.trailing).offset(-22)
            make.centerY.equalTo(rectView.snp.top).offset(22)
            make.width.height.equalTo(32)
        }
        
        self.snp.makeConstraints { make in
            make.width.equalTo(245)
        }
    }
    
    //MARK: - Private Func
    
    private func setupStyle() {
        layer.anchorPoint = .init(x: 0.5, y: 1)
        
        rectView.do { view in
            view.backgroundColor = .main(.main3)
            view.roundCorners(cornerRadius: 10)
        }
        
        nameLabel.setContentCompressionResistancePriority(UILayoutPriority(1000), for: .horizontal)
        nameLabel.do { label in
            label.font = .offroad(style: .iosTooltipTitle)
            label.textColor = .main(.main2)
            label.numberOfLines = 0
            label.textAlignment = .left
        }
        
        offroadLogoImageView.do { imageView in
            imageView.contentMode = .scaleAspectFit
        }
        
        nameAndImageStackView.do { stackView in
            stackView.axis = .horizontal
            stackView.spacing = 5
            stackView.alignment = .center
            stackView.distribution = .fill
        }
        
        shortDescriptionLabel.do { label in
            label.font = .offroad(style: .iosTextContents)
            label.numberOfLines = 0
            label.lineBreakStrategy = .hangulWordPriority
            label.textColor = .main(.main2)
            label.textAlignment = .left
        }
        
        addressLabel.do { label in
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
            button.setTitleColor(.primary(.white), for: .normal)
            button.configureBackgroundColorWhen(normal: .sub(.sub4),
                                                highlighted: .sub(.sub480),
                                                disabled: .grayscale(.gray200))
            button.configureTitleFontWhen(normal: .offroad(style: .iosBtnSmall))
            button.configuration?.baseForegroundColor = .primary(.white)
            button.roundCorners(cornerRadius: 5)
        }
        
        closeButton.do { button in
            button.setImage(.btnPlaceInfoPopupClose, for: .normal)
            button.configureBackgroundColorWhen(normal: .clear, highlighted: .grayscale(.gray100))
        }
    }
    
    private func setupHierarchy() {
        addSubviews(
            tooltipImageView,
            rectView
        )
        rectView.addSubviews(
            offroadLogoImageView,
            nameAndImageStackView,
            shortDescriptionLabel,
            addressLabel,
            visitCountLabel,
            exploreButton,
            closeButton
        )
    }
    
    //MARK: - Func
    
    func setMarker(_ marker: ORBNMFMarker?) {
        self.marker = marker
    }
    
    /// 툴팁을 띄울 장소의 지도 뷰 상에서 위치. 툴팁이 마커 정보를 갖고 있지 않으면 `nil`을 반환.
    /// - Parameter mapView: 툴팁이 표시될 지도. `NMFMapView` 타입
    /// - Returns: 툴팁이 지도 뷰 상에 표시할 좌표.
    func getPoint(in mapView: NMFMapView) -> CGPoint? {
        guard let marker else { return nil }
        return mapView.projection.point(from: marker.position)
    }
    
}
        
