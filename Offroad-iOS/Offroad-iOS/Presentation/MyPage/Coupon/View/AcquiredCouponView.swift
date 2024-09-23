//
//  AcquiredCouponView.swift
//  Offroad-iOS
//
//  Created by  정지원 on 8/27/24.
//

import UIKit

import SnapKit

class AcquiredCouponView: UIView {
    
    // MARK: - UI Properties
    
    let customBackButton = NavigationPopButton().then {
        $0.configureButtonTitle(titleString: "마이페이지")
    }
    
    private let labelView = UIView().then {
        $0.backgroundColor = UIColor.main(.main1)
    }
    
    private let mainLabel = UILabel().then {
        $0.text = "획득 쿠폰"
        $0.textColor = UIColor.main(.main2)
        $0.textAlignment = .center
        $0.font = UIFont.offroad(style: .iosTextTitle)
    }
    
    private var couponLogoImage = UIImageView(image: UIImage(resource: .imgCoupon))
    
    let customSegmentedControl = CustomSegmentedControl(titles: ["사용 가능 6", "사용 완료 3"])
    
    private lazy var collectionViewLayoutForAvailableCoupons = UICollectionViewFlowLayout().then {
        let horizontalInset: CGFloat = 24
        let verticalInset: CGFloat = 20
        let interItemSpacing: CGFloat = 20
        let lineSpacing: CGFloat = 20
        let itemWidth = (UIScreen.current.bounds.width - 2 * horizontalInset - interItemSpacing)/2
        $0.minimumInteritemSpacing = interItemSpacing
        $0.minimumLineSpacing = lineSpacing
        $0.sectionInset = .init(top: verticalInset, left: horizontalInset, bottom: verticalInset, right: horizontalInset)
        $0.estimatedItemSize = .init(width: itemWidth, height: itemWidth)
    }
    
    lazy var collectionViewForAvailableCoupons = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayoutForAvailableCoupons).then {
        $0.register(AvailableCouponCell.self, forCellWithReuseIdentifier: "AvailableCouponCell")
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = false
    }
    
    private lazy var collectionViewLayoutForUsedCoupons = UICollectionViewFlowLayout().then {
        let horizontalInset: CGFloat = 24
        let verticalInset: CGFloat = 20
        let interItemSpacing: CGFloat = 20
        let lineSpacing: CGFloat = 20
        let itemWidth = (UIScreen.current.bounds.width - 2 * horizontalInset - interItemSpacing)/2
        $0.minimumInteritemSpacing = interItemSpacing
        $0.minimumLineSpacing = lineSpacing
        $0.sectionInset = .init(top: verticalInset, left: horizontalInset, bottom: verticalInset, right: horizontalInset)
        $0.estimatedItemSize = .init(width: itemWidth, height: itemWidth)
    }
    
    lazy var collectionViewForUsedCoupons = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayoutForUsedCoupons).then {
        $0.register(UsedCouponCell.self, forCellWithReuseIdentifier: "UsedCouponCell")
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = false
    }
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Functions
    
    private func setupStyle() {
        backgroundColor = .primary(.listBg)
    }
    
    private func setupHierarchy() {
        addSubviews(
            labelView,
            collectionViewForAvailableCoupons,
            collectionViewForUsedCoupons
        )
        labelView.addSubviews(
            customBackButton,
            mainLabel,
            couponLogoImage,
            customSegmentedControl
        )
    }
    
    private func setupLayout() {
        customBackButton.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(12)
            $0.leading.equalToSuperview().inset(12)
        }
        
        labelView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(customSegmentedControl.snp.bottom)
        }
        
        mainLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(95)
            make.leading.equalToSuperview().inset(23)
        }
        
        couponLogoImage.snp.makeConstraints { make in
            make.centerY.equalTo(mainLabel)
            make.leading.equalTo(mainLabel.snp.trailing).offset(8)
            make.size.equalTo(24)
        }
        
        customSegmentedControl.snp.makeConstraints { make in
            make.top.equalTo(mainLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(46)
        }
        
        collectionViewForAvailableCoupons.snp.makeConstraints { make in
            make.top.equalTo(customSegmentedControl.snp.bottom)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
        collectionViewForUsedCoupons.snp.makeConstraints { make in
            make.top.equalTo(customSegmentedControl.snp.bottom)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
}
