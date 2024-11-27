//
//  UsedCouponCell.swift
//  Offroad-iOS
//
//  Created by 김민성 on 9/23/24.
//

import UIKit

final class CouponCell: UICollectionViewCell {
    
    // MARK: - UI Properties
    
    var couponInfo: CouponInfo? = nil
    private var couponimageView = UIImageView()
    private let couponNameLabel = UILabel()
    private let newTagImageView = UIImageView()
    private let isUsedView = UIView()
    private let isUsedImageView = UIImageView(image: .icnCouponListCheckmark)
    
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
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        newTagImageView.isHidden = true
        couponInfo = nil
    }
    
    // MARK: - Setup Functions
    
    private func setupStyle() {
        contentView.roundCorners(cornerRadius: 12)
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.home(.homeContents2).cgColor
        contentView.backgroundColor = UIColor.main(.main1)
        
        couponimageView.do { imageView in
            imageView.backgroundColor = .primary(.white)
            imageView.roundCorners(cornerRadius: 10)
            imageView.contentMode = .scaleAspectFit
        }
        
        couponNameLabel.do { label in
            label.textAlignment = .center
            label.textColor = UIColor.main(.main2)
            label.font = UIFont.offroad(style: .iosTextContentsSmall)
        }
        
        newTagImageView.do {
            $0.image = UIImage(resource: .imgNewTag)
            $0.isHidden = true
        }
        
        isUsedView.do { view in
            view.backgroundColor = .blackOpacity(.black25)
        }
    }
    
    private func setupHierarchy() {
        contentView.addSubviews(
            couponimageView,
            couponNameLabel,
            isUsedView,
            newTagImageView
        )
        isUsedView.addSubview(isUsedImageView)
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
        
        newTagImageView.snp.makeConstraints { make in
            make.top.trailing.equalTo(couponimageView).inset(8)
            make.size.equalTo(24)
        }
        
        isUsedView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        isUsedImageView.snp.makeConstraints { make in
            make.center.equalTo(couponimageView)
            make.size.equalTo(32)
        }
    }
    
    func configureAvailableCell(with coupon: CouponInfo) {
        couponInfo = coupon
        couponNameLabel.text = coupon.name
        couponNameLabel.text = coupon.name
        newTagImageView.isHidden = !(coupon.isNewGained ?? false)
        couponimageView.fetchSvgURLToImageView(svgUrlString: coupon.couponImageUrl)
        isUsedView.isHidden = true
    }
    
    func configureUsedCell(with coupon: CouponInfo) {
        couponInfo = coupon
        couponNameLabel.text = coupon.name
        couponNameLabel.text = coupon.name
        couponimageView.fetchSvgURLToImageView(svgUrlString: coupon.couponImageUrl)
        isUsedView.isHidden = false
    }
}

