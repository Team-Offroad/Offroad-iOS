//
//  CouponListView.swift
//  Offroad-iOS
//
//  Created by  정지원 on 8/27/24.
//

import UIKit

import Lottie
import SnapKit

class CouponListView: UIView {
    
    // MARK: - UI Properties
    
    let customBackButton = NavigationPopButton()
    let pageViewController = UIPageViewController(transitionStyle: .scroll, navigationOrientation: .horizontal)
    
    private let labelView = UIView()
    private let mainLabel = UILabel()
    private var couponLogoImage = UIImageView(image: UIImage(resource: .imgCoupon))
    
    let segmentedControl = ORBSegmentedControl(titles: ["사용 가능 0", "사용 완료 0"])
    let separator = UIView()
    
    private var layoutMaker: UICollectionViewFlowLayout {
        let horizontalInset: CGFloat = 24
        let verticalInset: CGFloat = 0
        let interItemSpacing: CGFloat = 20
        let lineSpacing: CGFloat = 20
        let itemWidth = floor((UIScreen.current.bounds.width - 2 * horizontalInset - interItemSpacing)/2)
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = interItemSpacing
        layout.minimumLineSpacing = lineSpacing
        layout.sectionInset = .init(top: verticalInset, left: horizontalInset, bottom: verticalInset, right: horizontalInset)
        layout.itemSize = .init(width: itemWidth, height: itemWidth + 32)
        return layout
    }
    
    lazy var collectionViewForAvailableCoupons = UICollectionView(frame: .zero, collectionViewLayout: layoutMaker)
    lazy var collectionViewForUsedCoupons = UICollectionView(frame: .zero, collectionViewLayout: layoutMaker)
    let loadingView = LottieAnimationView(name: "loading1")
    
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
        
        separator.do { view in
            view.backgroundColor = .grayscale(.gray100)
        }
        
        collectionViewForAvailableCoupons.do { collectionView in
            collectionView.register(CouponCell.self, forCellWithReuseIdentifier: CouponCell.className)
            collectionView.backgroundColor = .clear
            collectionView.indicatorStyle = .black
            collectionView.contentInsetAdjustmentBehavior = .never
            collectionView.contentInset = .init(top: 20, left: 0, bottom: 87, right: 0)
        }
        
        collectionViewForUsedCoupons.do { collectionView in
            collectionView.register(CouponCell.self, forCellWithReuseIdentifier: CouponCell.className)
            collectionView.backgroundColor = .clear
            collectionView.indicatorStyle = .black
            collectionView.contentInsetAdjustmentBehavior = .never
            collectionView.contentInset = .init(top: 20, left: 0, bottom: 87, right: 0)
        }
        
        loadingView.do { animationView in
            animationView.contentMode = .scaleAspectFit
            animationView.loopMode = .loop
        }
    }
    
    private func setupHierarchy() {
        addSubviews(
            labelView,
            pageViewController.view,
            separator
        )
        
        labelView.addSubviews(
            customBackButton,
            mainLabel,
            couponLogoImage,
            segmentedControl
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
            make.bottom.equalTo(segmentedControl.snp.bottom)
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
        
        segmentedControl.snp.makeConstraints { make in
            make.top.equalTo(mainLabel.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(46)
            make.bottom.equalToSuperview()
        }
        
        separator.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(1)
        }
        
        pageViewController.view.snp.makeConstraints { make in
            make.top.equalTo(labelView.snp.bottom)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
}
