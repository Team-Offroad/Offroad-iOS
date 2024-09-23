//
//  SelectMainCharacterView.swift
//  Offroad-iOS
//
//  Created by  정지원 on 9/24/24.
//
import UIKit

import SnapKit
import Then

class SelectMainCharacterView: UIView {

    // MARK: - UI Properties
    
    private let selectMessageBackgroundView = UIView().then {
        $0.backgroundColor = UIColor.blackOpacity(.black55)
        $0.layer.cornerRadius = 10
    }
    
    private let checkmarkImageView = UIImageView().then {
        $0.image = UIImage(resource: .btnChecked)
    }
    
    private let selectMessageLabel = UILabel().then {
        $0.font = UIFont.offroad(style: .iosTextMedium)
        $0.textColor = UIColor.primary(.white)
    }
    
    // MARK: - Life Cycle
    
    init(frame: CGRect, characterName: String) {
        super.init(frame: frame)
        
        setupHierarchy()
        setupLayout()
        setMessage(characterName: characterName)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private Func
    
    private func setupHierarchy() {
        addSubview(selectMessageBackgroundView)
        selectMessageBackgroundView.addSubview(checkmarkImageView)
        selectMessageBackgroundView.addSubview(selectMessageLabel)
    }
    
    private func setupLayout() {
        selectMessageBackgroundView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        checkmarkImageView.snp.makeConstraints { make in
            make.leading.equalTo(selectMessageBackgroundView).inset(20)
            make.centerY.equalTo(selectMessageBackgroundView)
            make.size.equalTo(24)
        }
        
        selectMessageLabel.snp.makeConstraints { make in
            make.leading.equalTo(checkmarkImageView.snp.trailing).offset(10)
            make.centerY.equalTo(selectMessageBackgroundView)
        }
    }
    
    private func setMessage(characterName: String) {
        selectMessageLabel.text = "‘\(characterName)’로 대표 캐릭터가 변경되었어요!"
        selectMessageLabel.highlightText(targetText: characterName, font: UIFont.offroad(style: .iosTextBold))
    }
}
