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
    
    let customBackButton = NavigationPopButton()
    
    private let labelView = UIView()
    private let mainLabel = UILabel()
    private var couponLogoImage = UIImageView(image: UIImage(resource: .imgCoupon))
    
    let customSegmentedControl = CustomSegmentedControl(titles: ["사용 가능 6", "사용 완료 3"])
    
    private var layoutMaker: UICollectionViewFlowLayout {
        let horizontalInset: CGFloat = 24
        let verticalInset: CGFloat = 20
        let interItemSpacing: CGFloat = 20
        let lineSpacing: CGFloat = 20
        let itemWidth = (UIScreen.current.bounds.width - 2 * horizontalInset - interItemSpacing)/2
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = interItemSpacing
        layout.minimumLineSpacing = lineSpacing
        layout.sectionInset = .init(top: verticalInset, left: horizontalInset, bottom: verticalInset, right: horizontalInset)
        layout.estimatedItemSize = .init(width: itemWidth, height: itemWidth)
        return layout
    }
    
    lazy var collectionViewForAvailableCoupons = UICollectionView(frame: .zero, collectionViewLayout: layoutMaker)
    lazy var collectionViewForUsedCoupons = UICollectionView(frame: .zero, collectionViewLayout: layoutMaker)
    
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
        
        customBackButton.configureButtonTitle(titleString: "마이페이지")
        labelView.backgroundColor = UIColor.main(.main1)
        
        mainLabel.do { label in
            label.text = "획득 쿠폰"
            label.textColor = UIColor.main(.main2)
            label.textAlignment = .center
            label.font = UIFont.offroad(style: .iosTextTitle)
        }
        
        collectionViewForAvailableCoupons.do { collectionView in
            collectionView.register(AvailableCouponCell.self, forCellWithReuseIdentifier: AvailableCouponCell.className)
            collectionView.backgroundColor = .clear
            collectionView.showsVerticalScrollIndicator = false
        }
        
        collectionViewForUsedCoupons.do { collectionView in
            collectionView.register(UsedCouponCell.self, forCellWithReuseIdentifier: UsedCouponCell.className)
            collectionView.backgroundColor = .clear
            collectionView.showsVerticalScrollIndicator = false
        }
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
            make.bottom.equalToSuperview()
        }
        
        collectionViewForAvailableCoupons.snp.makeConstraints { make in
            make.top.equalTo(labelView.snp.bottom)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
        collectionViewForUsedCoupons.snp.makeConstraints { make in
            make.top.equalTo(labelView.snp.bottom)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
}
