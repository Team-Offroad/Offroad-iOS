//
//  SettingView.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 8/7/24.
//

import UIKit

import SnapKit
import Then

final class SettingView: SettingBaseView {
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension SettingView {
    
    // MARK: - Layout
    
    private func setupStyle() {
        backgroundColor = .primary(.listBg)
        
        titleLabel.do {
            $0.text = "설정"
        }
        
        titleImageView.do {
            $0.image = UIImage(resource: .imgCogwheel)
        }
        
        customBackButton.do {
            $0.configureButtonTitle(titleString: "마이페이지")
        }
    }
}
