//
//  AcquiredCouponCell.swift
//  Offroad-iOS
//
//  Created by  정지원 on 8/27/24.
//

import UIKit

import SnapKit

class AcquiredCouponCell: UICollectionViewCell {
    
    // MARK: - UI Properties
    
    private let containerView = UIView().then {
        $0.backgroundColor = .white
        $0.roundCorners(cornerRadius: 10)
        $0.clipsToBounds = true
    }
    
    private var imageView = UIImageView().then {
        $0.contentMode = .scaleToFill
        $0.clipsToBounds = true
    }
    
    private let couponLabel = UILabel().then {
        $0.textAlignment = .center
        $0.textColor = UIColor.main(.main2)
        $0.font = UIFont.offroad(style: .iosTextContentsSmall)
    }
    
    private let newBadgeView = UIImageView().then {
        $0.contentMode = .scaleAspectFit
        $0.image = UIImage(resource: .imgNewTag)
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
            containerView,
            couponLabel,
            newBadgeView
        )
        containerView.addSubview(imageView)
    }
    
    private func setupStyle() {
        contentView.roundCorners(cornerRadius: 12)
        contentView.layer.borderWidth = 1
        contentView.layer.borderColor = UIColor.home(.homeContents2).cgColor
        contentView.clipsToBounds = true
        contentView.backgroundColor = UIColor.main(.main1)
    }
    
    private func setupLayout() {
        containerView.snp.makeConstraints { make in
            make.horizontalEdges.top.equalToSuperview().inset(10)
            make.bottom.equalTo(contentView).inset(42)
        }
        
        imageView.snp.makeConstraints { make in
            make.size.equalTo(142)
            make.centerX.equalToSuperview()
        }
        
        couponLabel.snp.makeConstraints { make in
            make.top.equalTo(containerView.snp.bottom).offset(10)
            make.bottom.equalToSuperview().inset(10)
            make.centerX.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(10)
        }
        
        newBadgeView.snp.makeConstraints { make in
            make.top.trailing.equalTo(containerView).inset(8)
            make.size.equalTo(24)
        }
    }
    
    func configureCell(imageName: String, isNew: Bool) {
        imageView.image = UIImage(named: imageName)
        
        newBadgeView.isHidden = !isNew
        
        if imageName == "coffee_coupon" {
            couponLabel.text = "카페 프로토콜 연희점 라떼 1잔입니다."
        }
    }
}