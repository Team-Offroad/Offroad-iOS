//
//  BirthView.swift
//  Offroad-iOS
//
//  Created by  정지원 on 7/9/24.
//

import UIKit

import SnapKit
import Then

final class BirthView: UIView {
    
    //MARK: - Properties
    
    let skipButton = UIButton().then {
        $0.setTitle("건너뛰기", for: .normal)
        $0.setTitleColor(UIColor.grayscale(.gray300), for: .normal)
        $0.titleLabel?.font =  UIFont.offroad(style: .iosHint)
    }
    
    private let mainLabel = UILabel().then {
        $0.text = "모험가 프로필 작성"
        $0.textAlignment = .center
        $0.textColor = UIColor.main(.main2)
        $0.font = UIFont.offroad(style: .iosProfileTitle)
    }
    
    private let subLabel = UILabel().then {
        $0.text = "나이를 알려주세요."
        $0.textAlignment = .center
        $0.textColor = UIColor.main(.main2)
        $0.font = UIFont.offroad(style: .iosSubtitleReg)
    }
    
    private let birthLabel = UILabel().then {
        $0.text = "생년월일 입력"
        $0.textAlignment = .center
        $0.textColor = UIColor.main(.main2)
        $0.font = UIFont.offroad(style: .iosSubtitle2Semibold)
    }
    
    let yearTextField = UITextField().then {
        $0.keyboardType = .numberPad
        $0.backgroundColor = UIColor.main(.main3)
        $0.layer.borderWidth = 1.0
        $0.roundCorners(cornerRadius: 5)
        $0.layer.borderColor = UIColor.grayscale(.gray100).cgColor
        $0.textColor = UIColor.main(.main2)
        $0.textAlignment = .center
        $0.attributedPlaceholder = NSAttributedString(
            string: "YYYY",
            attributes: [NSAttributedString.Key.font: UIFont.offroad(style: .iosTextAuto), NSAttributedString.Key.foregroundColor: UIColor.grayscale(.gray300)]
        )
    }
    
    let monthTextField = UITextField().then {
        $0.keyboardType = .numberPad
        $0.backgroundColor = UIColor.main(.main3)
        $0.layer.borderWidth = 1.0
        $0.roundCorners(cornerRadius: 5)
        $0.layer.borderColor = UIColor.grayscale(.gray100).cgColor
        $0.textColor = UIColor.main(.main2)
        $0.textAlignment = .center
        $0.attributedPlaceholder = NSAttributedString(
            string: "MM",
            attributes: [NSAttributedString.Key.font: UIFont.offroad(style: .iosTextAuto), NSAttributedString.Key.foregroundColor: UIColor.grayscale(.gray300)]
        )
    }
    
    let dayTextField = UITextField().then {
        $0.keyboardType = .numberPad
        $0.backgroundColor = UIColor.main(.main3)
        $0.layer.borderWidth = 1.0
        $0.roundCorners(cornerRadius: 5)
        $0.layer.borderColor = UIColor.grayscale(.gray100).cgColor
        $0.textColor = UIColor.main(.main2)
        $0.textAlignment = .center
        $0.attributedPlaceholder = NSAttributedString(
            string: "DD",
            attributes: [NSAttributedString.Key.font: UIFont.offroad(style: .iosTextAuto), NSAttributedString.Key.foregroundColor: UIColor.grayscale(.gray300)]
        )
    }
    
    let yearLabel = UILabel().then {
        $0.text = "년"
        $0.textColor = UIColor.main(.main2)
        $0.font = UIFont.offroad(style: .iosSubtitleReg)
    }
    
    let monthLabel = UILabel().then {
        $0.text = "월"
        $0.textColor = UIColor.main(.main2)
        $0.font = UIFont.offroad(style: .iosSubtitleReg)
    }
    
    let dayLabel = UILabel().then {
        $0.text = "일"
        $0.textColor = UIColor.main(.main2)
        $0.font = UIFont.offroad(style: .iosSubtitleReg)
    }
    
    let notionLabel = UILabel().then {
        $0.text = ""
        $0.textColor = UIColor.primary(.errorNew)
        $0.font = UIFont.offroad(style: .iosHint)
    }
    
    let nextButton = StateToggleButton(state: .isDisabled, title: "다음")

    
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

extension BirthView {
    
    // MARK: - Private Func
    
    private func setupHierarchy() {
        addSubviews(
            mainLabel,
            subLabel,
            birthLabel,
            yearTextField,
            monthTextField,
            dayTextField,
            yearLabel,
            monthLabel,
            dayLabel,
            notionLabel,
            nextButton,
            skipButton
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
        
        birthLabel.snp.makeConstraints{ make in
            make.top.equalTo(subLabel.snp.bottom).offset(64)
            make.leading.equalToSuperview().inset(24)
        }
        
        yearTextField.snp.makeConstraints { make in
            make.top.equalTo(birthLabel.snp.bottom).offset(14)
            make.leading.equalToSuperview().inset(24)
            make.height.equalTo(48)
            make.width.equalTo(93)
        }
        
        yearLabel.snp.makeConstraints { make in
            make.top.equalTo(birthLabel.snp.bottom).offset(26)
            make.leading.equalTo(yearTextField.snp.trailing).offset(6)
        }
        
        monthTextField.snp.makeConstraints { make in
            make.top.equalTo(birthLabel.snp.bottom).offset(14)
            make.leading.equalTo(yearLabel.snp.trailing).offset(6)
            make.height.equalTo(48)
            make.width.equalTo(73)
        }
        
        monthLabel.snp.makeConstraints { make in
            make.top.equalTo(birthLabel.snp.bottom).offset(26)
            make.leading.equalTo(monthTextField.snp.trailing).offset(6)
        }
        
        dayTextField.snp.makeConstraints { make in
            make.top.equalTo(birthLabel.snp.bottom).offset(14)
            make.leading.equalTo(monthLabel.snp.trailing).offset(6)
            make.height.equalTo(48)
            make.width.equalTo(73)
        }
        
        dayLabel.snp.makeConstraints { make in
            make.top.equalTo(birthLabel.snp.bottom).offset(26)
            make.leading.equalTo(dayTextField.snp.trailing).offset(6)
        }
        
        notionLabel.snp.makeConstraints { make in
            make.top.equalTo(yearTextField.snp.bottom).offset(12)
            make.leading.equalToSuperview().inset(24)
        }
        
        nextButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).inset(24)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(54)
        }
    }
}
