//
//  GenderView.swift
//  Offroad-iOS
//
//  Created by  정지원 on 7/10/24.
//

import UIKit

import SnapKit
import Then

final class GenderView: UIView {
    
    //MARK: - Properties
    
    private let mainLabel = UILabel().then {
        $0.text = "모험가 프로필 작성"
        $0.textAlignment = .center
        $0.textColor = UIColor.main(.main2)
        $0.font = UIFont.offroad(style: .iosProfileTitle)
    }
    
    private let subLabel = UILabel().then {
        $0.text = "성별을 선택해 주세요."
        $0.textAlignment = .center
        $0.textColor = UIColor.main(.main2)
        $0.font = UIFont.offroad(style: .iosSubtitleReg)
    }
    
    private let maleButton = UIButton().then {
        $0.setTitle("남성", for: .normal)
        $0.titleLabel?.textAlignment = .center
        $0.titleLabel?.font = UIFont.offroad(style: .iosTextRegular)
        $0.setTitleColor(UIColor.grayscale(.gray300), for: .normal)
        $0.backgroundColor = UIColor.main(.main3)
        $0.layer.borderColor = UIColor.grayscale(.gray100).cgColor
        $0.layer.cornerRadius = 5
    }
    
    private let femaleButton = UIButton().then {
        $0.setTitle("여성", for: .normal)
        $0.titleLabel?.textAlignment = .center
        $0.titleLabel?.font = UIFont.offroad(style: .iosTextRegular)
        $0.setTitleColor(UIColor.grayscale(.gray300), for: .normal)
        $0.backgroundColor = UIColor.main(.main3)
        $0.layer.borderColor = UIColor.grayscale(.gray100).cgColor
        $0.layer.cornerRadius = 5
    }
    
    private let etcButton = UIButton().then {
        $0.setTitle("기타", for: .normal)
        $0.titleLabel?.textAlignment = .center
        $0.titleLabel?.font = UIFont.offroad(style: .iosTextRegular)
        $0.setTitleColor(UIColor.grayscale(.gray300), for: .normal)
        $0.backgroundColor = UIColor.main(.main3)
        $0.layer.borderColor = UIColor.grayscale(.gray100).cgColor
        $0.layer.cornerRadius = 5
    }
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupHierarchy()
        setupStyle()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension GenderView {
    
    // MARK: - Private Func
    
    private func setupHierarchy() {
        addSubviews(
            mainLabel,
            subLabel,
            maleButton,
            femaleButton,
            etcButton
        )
    }
    
    private func setupStyle() {
        backgroundColor = UIColor.main(.main1)
    }
    
    private func setupLayout() {
        
        mainLabel.snp.makeConstraints{ make in
            make.top.equalTo(safeAreaLayoutGuide).inset(97)
            make.leading.trailing.equalToSuperview().inset(63)
        }
        
        subLabel.snp.makeConstraints{ make in
            make.top.equalTo(mainLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(63)
        }
        
        maleButton.snp.makeConstraints { make in
            make.top.equalTo(subLabel.snp.bottom).offset(64)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(60)
        }
        
        femaleButton.snp.makeConstraints { make in
            make.top.equalTo(maleButton.snp.bottom).offset(64)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(60)
        }
        
        etcButton.snp.makeConstraints { make in
            make.top.equalTo(femaleButton.snp.bottom).offset(64)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(60)
        }
    }
}



