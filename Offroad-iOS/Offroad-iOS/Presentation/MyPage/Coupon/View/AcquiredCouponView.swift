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
    
    private lazy var collectionViewLayout = UICollectionViewFlowLayout().then {
        let padding: CGFloat = 20
        let itemWidth = (UIScreen.main.bounds.width - 2*24 - padding)/2
        let itemHeight: CGFloat = itemWidth * (194 / 162)
        $0.itemSize = CGSize(width: itemWidth, height: itemHeight)
        $0.minimumLineSpacing = padding
        $0.minimumInteritemSpacing = padding
        
        $0.sectionInset.top = 20
    }
    
    lazy var collectionView = UICollectionView(frame: .zero, collectionViewLayout: collectionViewLayout).then {
        $0.register(AcquiredCouponCell.self, forCellWithReuseIdentifier: "AcquiredCouponCell")
        $0.backgroundColor = .clear
        $0.showsVerticalScrollIndicator = false
    }
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupDelegates()
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
            collectionView
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
        
        collectionView.snp.makeConstraints { make in
            make.top.equalTo(customSegmentedControl.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().inset(20)
        }
    }
    
    private func setupDelegates() {
        customSegmentedControl.delegate = self
    }
}

extension AcquiredCouponView: CustomSegmentedControlDelegate {
    func segmentedControlDidSelected(segmentedControl: CustomSegmentedControl, selectedIndex: Int) {
        print(#function, selectedIndex)
        
        if selectedIndex == 0 {
            
        } else if selectedIndex == 1 {
            
        }
    }
}