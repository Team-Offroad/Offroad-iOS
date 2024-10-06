//
//  UsedCouponCell.swift
//  Offroad-iOS
//
//  Created by 김민성 on 9/23/24.
//

import UIKit

class UsedCouponCell: UICollectionViewCell {
    
    // MARK: - UI Properties
    
    private var couponimageView = UIImageView()
    private let couponNameLabel = UILabel()
    private let dimmedView = UIView()
    private let checkMark = UIImageView(image: .icnCouponListCheckmark)
    
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
            couponimageView,
            couponNameLabel,
            dimmedView,
            checkMark
        )
    }
    
    private func setupStyle() {
        contentView.roundCorners(cornerRadius: 12)
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.home(.homeContents2).cgColor
        contentView.clipsToBounds = true
        contentView.backgroundColor = UIColor.main(.main1)
        
        couponimageView.do { imageView in
            imageView.backgroundColor = .primary(.white)
            imageView.roundCorners(cornerRadius: 10)
            imageView.contentMode = .scaleAspectFit
            imageView.clipsToBounds = true
        }
        
        couponNameLabel.do { label in
            label.textAlignment = .center
            label.textColor = UIColor.main(.main2)
            label.font = UIFont.offroad(style: .iosTextContentsSmall)
        }
        
        dimmedView.do { view in
            view.backgroundColor = .blackOpacity(.black25)
        }
    }
    
    private func setupLayout() {
        couponimageView.snp.makeConstraints { make in
            // collectionView의 가로 sectionInset: 24
            // collectionView's interItemSpacing: 20
            let imageViewHorizontalInset: CGFloat = 10
            let imageWidth = floor((UIScreen.current.bounds.width - 24*2 - 20)/2 - imageViewHorizontalInset*2)
            make.size.equalTo(imageWidth)
            make.top.horizontalEdges.equalToSuperview().inset(imageViewHorizontalInset)
        }
        
        couponNameLabel.snp.makeConstraints { make in
            make.top.equalTo(couponimageView.snp.bottom).offset(14)
            make.bottom.equalToSuperview().inset(14)
            make.horizontalEdges.equalToSuperview().inset(10)
        }
        
        dimmedView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        checkMark.snp.makeConstraints { make in
            make.center.equalTo(couponimageView)
            make.size.equalTo(32)
        }
    }
    
    func configure(with coupon: UsedCoupon) {
        couponNameLabel.text = coupon.name
    }
    
}
