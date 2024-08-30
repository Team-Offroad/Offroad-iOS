//
//  NoticeView.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 8/7/24.
//

import UIKit

import SnapKit
import Then

final class NoticeView: SettingBaseView {
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NoticeView {
    
    // MARK: - Layout
    
    private func setupStyle() {
        titleLabel.do {
            $0.text = "공지사항"
        }
        
        titleImageView.do {
            $0.image = UIImage(resource: .imgLoudspeaker)
        }
        
        customBackButton.do {
            $0.configureButtonTitle(titleString: "설정")
        }
    }
}
