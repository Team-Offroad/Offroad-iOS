//
//  MyPageCustomButton.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 10/22/24.
//

import UIKit

import SnapKit
import Then

final class MyPageCustomButton: UIButton {
    
    //MARK: - UI Properties
    
    private let customTitleLabel = UILabel()
    private let backgroundImageView = UIImageView()
    
    //MARK: - Life Cycle
    
    init(titleString: String, backgroundImage: UIImage) {
        super.init(frame: .zero)
        
        setupHierarchy()
        setupStyle(forString: titleString, forImage: backgroundImage)
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension MyPageCustomButton {
    
    // MARK: - Layout
    
    private func setupStyle(forString: String, forImage: UIImage) {
        setImage(forImage, for: .normal)
        clipsToBounds = true
        
        customTitleLabel.do {
            $0.text = forString
            $0.textColor = .sub(.sub4)
            $0.textAlignment = .center
            $0.font = .offroad(style: .iosTextBold)
        }
    }
    
    private func setupHierarchy() {
        addSubview(customTitleLabel)
    }
    
    private func setupLayout() {
        customTitleLabel.snp.makeConstraints {
            $0.top.leading.equalToSuperview().inset(17)
        }
    }
}
