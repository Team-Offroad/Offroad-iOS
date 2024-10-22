//
//  ORBAlertViewScrollableContent.swift
//  Offroad-iOS
//
//  Created by 김민성 on 10/19/24.
//

import UIKit

final class ORBAlertViewScrollableContent: ORBAlertBaseView, ORBAlertViewBaseUI {
    
    let type: ORBAlertType = .scrollableContent
    let contentView = UIView()
    let scrollableContentView = UIView()
    
    override func setupHierarchy() {
        addSubviews(contentView, closeButton)
        contentView.addSubviews(titleLabel, scrollableContentView, buttonStackView)
    }
    
    override func setupLayout() {
        super.setupLayout()
        
        contentView.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(topInset)
            make.leading.equalToSuperview().inset(leftInset)
            make.trailing.equalToSuperview().inset(rightInset)
            make.bottom.equalToSuperview().inset(bottomInset)
            make.height.greaterThanOrEqualTo(182)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.horizontalEdges.equalToSuperview()
        }
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        scrollableContentView.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(350)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(scrollableContentView.snp.bottom).offset(24)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
}
