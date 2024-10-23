//
//  ORBAlertViewExplorationResult.swift
//  Offroad-iOS
//
//  Created by 김민성 on 10/19/24.
//

import UIKit

final class ORBAlertViewExplorationResult: ORBAlertBaseView, ORBAlertViewBaseUI {
    
    let type: ORBAlertType = .explorationResult
    let contentView = UIView()
    let explorationResultImageView = UIImageView()
    
    override func setupHierarchy() {
        addSubviews(contentView, closeButton)
        contentView.addSubviews(titleLabel, messageLabel, explorationResultImageView, buttonStackView)
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
        
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(10)
            make.horizontalEdges.equalToSuperview()
        }
        
        explorationResultImageView.snp.makeConstraints { make in
            make.top.equalTo(messageLabel.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(182)
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.top.equalTo(explorationResultImageView.snp.bottom)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
}
