//
//  UsedCouponCell.swift
//  Offroad-iOS
//
//  Created by 김민성 on 9/23/24.
//

import UIKit

class UsedCouponCell: UICollectionViewCell {
    
    // MARK: - UI Properties
    
    private var imageView = UIImageView().then {
        $0.backgroundColor = .primary(.white)
        $0.roundCorners(cornerRadius: 10)
        $0.contentMode = .scaleAspectFit
        $0.clipsToBounds = true
    }
    
    private let couponNameLabel = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = UIColor.main(.main2)
        $0.font = UIFont.offroad(style: .iosTextContentsSmall)
    }
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupHierarchy()
        setupStyle()
        setupLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup Functions
    
    private func setupHierarchy() {
        contentView.addSubviews(
            imageView,
            couponNameLabel
        )
    }
    
    private func setupStyle() {
        contentView.roundCorners(cornerRadius: 12)
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.home(.homeContents2).cgColor
        contentView.clipsToBounds = true
        contentView.backgroundColor = UIColor.main(.main1)
    }
    
    private func setupLayout() {
        imageView.snp.makeConstraints { make in
            // collectionView의 가로 sectionInset: 24
            // collectionView's interItemSpacing: 20
            let imageViewHorizontalInset: CGFloat = 10
            let imageWidth = floor((UIScreen.current.bounds.width - 24*2 - 20)/2 - imageViewHorizontalInset*2)
            make.size.equalTo(imageWidth)
            make.top.horizontalEdges.equalToSuperview().inset(imageViewHorizontalInset)
        }
        
        couponNameLabel.snp.makeConstraints { make in
            make.top.equalTo(imageView.snp.bottom).offset(14)
            make.bottom.equalToSuperview().inset(14)
            make.horizontalEdges.equalToSuperview().inset(10)
        }
    }
    
    func configure(with coupon: UsedCoupon) {
        couponNameLabel.text = coupon.name
    }
    
}