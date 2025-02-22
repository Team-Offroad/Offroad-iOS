//
//  ORBAlertViewMessageOnly.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 2/23/25.
//

import UIKit

final class ORBAlertViewMessageOnly: ORBAlertBaseView, ORBAlertViewBaseUI {
    
    let type: ORBAlertType = .messageOnly
    let contentView = UIView()
    lazy var contentStackView: UIView = UIStackView(
        arrangedSubviews: [messageLabel, buttonStackView]
    ).then { stackView in
        stackView.spacing = 24
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
    }
    
    override func setupHierarchy() {
        super.setupHierarchy()
        addSubviews(contentView, closeButton)
        contentView.addSubview(contentStackView)
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
            make.height.greaterThanOrEqualTo(116)
        }
        
        contentStackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
    }
}
