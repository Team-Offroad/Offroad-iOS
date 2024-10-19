//
//  ORBAlertViewNormal.swift
//  Offroad-iOS
//
//  Created by 김민성 on 10/19/24.
//

import UIKit

final class ORBAlertViewNormal: ORBAlertBaseView, ORBAlertViewBaseUI {
    
    let type: OFRAlertType = .normal
    let contentView = UIView()
    lazy var contentStackView: UIView = UIStackView(
        arrangedSubviews: [titleLabel, spacerView1, messageLabel, spacerView2, buttonStackView]
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
        
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        spacerView1.setContentHuggingPriority(.init(0), for: .vertical)
        spacerView2.setContentHuggingPriority(.init(0), for: .vertical)
        spacerView1.setContentCompressionResistancePriority(.init(999), for: .vertical)
        spacerView2.setContentCompressionResistancePriority(.init(999), for: .vertical)
        spacerView2.snp.makeConstraints { make in
            make.height.equalTo(spacerView1)
        }
    }
    
}
