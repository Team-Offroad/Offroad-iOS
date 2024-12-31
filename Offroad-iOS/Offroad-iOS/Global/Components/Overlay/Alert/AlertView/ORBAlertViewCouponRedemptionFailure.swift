//
//  ORBAlertViewCouponRedemptionFailure.swift
//  Offroad-iOS
//
//  Created by 김민성 on 1/1/25.
//

import UIKit

final class ORBAlertViewCouponRedemptionFailure: ORBAlertBaseView, ORBAlertViewBaseUI {
    
    let type: ORBAlertType = .couponRedemptionFailure
    let contentView = UIView()
    let exclamationMarkImageView = UIImageView(image: .icnCouponDetailExclamationMarkCircle)
    let messageLabelContainerView = UIView()
    let messageLabelWithExclamationMark = UIView()
    
    lazy var contentStackView: UIView = UIStackView(
        arrangedSubviews: [titleLabel, spacerView1, messageLabelContainerView, spacerView2, buttonStackView]
    ).then { stackView in
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
    }
    
    private var spacerView1 = UIView()
    private var spacerView2 = UIView()
    
    override func setupHierarchy() {
        super.setupHierarchy()
        addSubviews(contentView, closeButton)
        contentView.addSubview(contentStackView)
        messageLabelContainerView.addSubview(messageLabelWithExclamationMark)
        messageLabelWithExclamationMark.addSubviews(exclamationMarkImageView, messageLabel)
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        closeButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(12)
            make.size.equalTo(44)
        }
        
        contentView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(topInset)
            make.leading.equalToSuperview().inset(leftInset)
            make.trailing.equalToSuperview().inset(rightInset)
            make.bottom.equalToSuperview().inset(bottomInset)
            make.height.greaterThanOrEqualTo(182)
        }
        
        contentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        exclamationMarkImageView.snp.makeConstraints { make in
            make.centerY.leading.equalToSuperview()
            make.size.equalTo(24)
        }
        
        messageLabel.snp.makeConstraints { make in
            make.top.trailing.bottom.equalToSuperview()
            make.leading.equalTo(exclamationMarkImageView.snp.trailing).offset(6)
        }
        
        messageLabelWithExclamationMark.snp.makeConstraints { make in
            make.centerX.top.bottom.equalToSuperview()
            make.leading.greaterThanOrEqualToSuperview()
            make.trailing.lessThanOrEqualToSuperview()
        }
        
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        spacerView1.setContentHuggingPriority(.init(0), for: .vertical)
        spacerView2.setContentHuggingPriority(.init(0), for: .vertical)
        spacerView1.setContentCompressionResistancePriority(.init(999), for: .vertical)
        spacerView2.setContentCompressionResistancePriority(.init(999), for: .vertical)
        spacerView2.snp.makeConstraints { make in
            make.height.equalTo(spacerView1)
        }
    }
    
    override func setupStyle() {
        super.setupStyle()
        
        messageLabel.do { label in
            label.font = .offroad(style: .iosSubtitle2Semibold)
            label.textColor = .primary(.errorNew)
        }
    }
    
}
