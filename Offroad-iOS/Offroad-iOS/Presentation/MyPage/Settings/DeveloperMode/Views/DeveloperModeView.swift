//
//  DeveloperModeView.swift
//  ORB_Dev
//
//  Created by 김민성 on 4/4/25.
//

import UIKit

import SnapKit
import Then

final class DeveloperModeView: SettingBaseView {
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension DeveloperModeView {
    
    // MARK: - Layout
    
    private func setupStyle() {
        titleLabel.do {
            $0.text = "개발자 모드"
        }
        
        titleImageView.do {
            $0.image = UIImage(systemName: "wrench.and.screwdriver")
            $0.contentMode = .scaleAspectFit
            $0.tintColor = .sub(.sub)
        }
        
        customBackButton.do {
            $0.configureButtonTitle(titleString: "설정")
        }
    }
    
}
