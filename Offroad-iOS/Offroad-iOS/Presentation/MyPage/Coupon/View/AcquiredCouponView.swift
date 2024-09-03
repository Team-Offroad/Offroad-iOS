//
//  AcquiredCouponView.swift
//  Offroad-iOS
//
//  Created by  정지원 on 8/27/24.
//

import UIKit

import SnapKit

class AcquiredCouponView: UIView {

    // MARK: - Properties
    
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

    let segmentedControl: UISegmentedControl = {
        let control = UISegmentedControl(items: ["사용 가능 6", "사용 완료 3"])
        control.selectedSegmentIndex = 0
        control.backgroundColor = .clear
        control.selectedSegmentTintColor = UIColor.main(.main2)
        control.setTitleTextAttributes([.foregroundColor: UIColor.gray], for: .normal)
        control.setTitleTextAttributes([.foregroundColor: UIColor.black], for: .selected)
        return control
    }()
    
    private lazy var collectionViewLayout = UICollectionViewFlowLayout().then {
        let padding: CGFloat = 20
        let itemWidth = (UIScreen.main.bounds.width - 2*24 - padding)/2
        let itemHeight: CGFloat = itemWidth * (194 / 162)
        $0.itemSize = CGSize(width: itemWidth, height: itemHeight)
        $0.minimumLineSpacing = padding
        $0.minimumInteritemSpacing = padding
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
            mainLabel,
            couponLogoImage,
            segmentedControl
        )
    }

    private func setupLayout() {
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
        }

        collectionView.snp.makeConstraints { make in
            make.top.equalTo(segmentedControl.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.bottom.equalToSuperview().inset(20)
        }
    }
}
