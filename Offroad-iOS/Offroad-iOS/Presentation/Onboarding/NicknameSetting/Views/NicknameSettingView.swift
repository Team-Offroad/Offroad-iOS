//
//  NicknameSettingView.swift
//  Offroad-iOS
//
//  Created by 김민성 on 12/1/24.
//

import UIKit

final class NicknameSettingView: UIView {
    
    let titleLabel = UILabel()
    let subTitleLabel = UILabel()
    let nicknameTextField = UITextField()
    let checkDuplicateButton = UIButton()
    let nicknameRulesLabel = UILabel()
    let nextButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension NicknameSettingView {
    
    //MARK: - Layout Func
    
    private func setupLayout() {
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(97)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(24)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(24)
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(subTitleLabel.snp.bottom).offset(64)
            make.leading.equalTo(safeAreaLayoutGuide).inset(24)
            make.height.equalTo(48)
        }
        
        checkDuplicateButton.snp.makeConstraints { make in
            make.centerY.equalTo(nicknameTextField)
            make.leading.equalTo(nicknameTextField.snp.trailing).offset(14)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(24)
            make.width.equalTo(90)
            make.height.equalTo(50)
        }
        
        nicknameRulesLabel.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom).offset(12)
            make.leading.equalTo(nicknameTextField)
        }
        
        nextButton.snp.makeConstraints { make in
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(24)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(24)
            make.height.equalTo(54)
        }
    }
    
    //MARK: - Private Func
    
    private func setupStyle() {
        backgroundColor = .main(.main1)
        
        titleLabel.do { label in
            label.text = "모험가 프로필 작성"
            label.textColor = .main(.main2)
            label.font = .offroad(style: .iosProfileTitle)
            label.textAlignment = .center
            label.numberOfLines = 0
        }
        
        subTitleLabel.do { label in
            label.text = "어떤 이름으로 불러드릴까요?"
            label.textColor = .main(.main2)
            label.font = .offroad(style: .iosSubtitleReg)
            label.textAlignment = .center
            label.numberOfLines = 0
        }
        
        nicknameTextField.do { textField in
            textField.textColor = .main(.main2)
            textField.backgroundColor = .main(.main3)
            textField.roundCorners(cornerRadius: 5)
            textField.layer.borderWidth = 1.0
            textField.layer.borderColor = UIColor.grayscale(.gray100).cgColor
            textField.attributedPlaceholder = NSAttributedString(
                string: "닉네임 입력",
                attributes: [.font: UIFont.offroad(style: .iosTextAuto),
                             .foregroundColor: UIColor.grayscale(.gray300)]
            )
            textField.addPadding(left: 13,right: 13)
            textField.roundCorners(cornerRadius: 5)
        }
        
        checkDuplicateButton.do { button in
            button.setTitle("중복확인", for: .normal)
            button.titleLabel?.textAlignment = .center
            button.setTitleColor(UIColor.primary(.white), for: .normal)
            button.setTitleColor(UIColor.primary(.white), for: .disabled)
            button.isEnabled = false
            button.roundCorners(cornerRadius: 5)
            button.configureTitleFontWhen(normal: .offroad(style: .iosBtnSmall))
            button.configureBackgroundColorWhen(normal: .main(.main2),
                                                highlighted: .main(.main2).withAlphaComponent(0.8),
                                                disabled: .blackOpacity(.black15))
        }
        
        nicknameRulesLabel.do { label in
            label.text = "*한글 2~8자, 영어 2~16자 이내로 작성해주세요."
            label.textColor = UIColor.grayscale(.gray400)
            label.font = UIFont.offroad(style: .iosHint)
            label.textAlignment = .left
            label.numberOfLines = 0
        }
        
        nextButton.do { button in
            button.setTitle("다음", for: .normal)
            button.setTitleColor(.primary(.white), for: .normal)
            button.setTitleColor(.primary(.white), for: .disabled)
            button.isEnabled = false
            button.roundCorners(cornerRadius: 5)
            button.configureTitleFontWhen(normal: .offroad(style: .iosText))
            button.configureBackgroundColorWhen(normal: .main(.main2),
                                                highlighted: .main(.main2).withAlphaComponent(0.8),
                                                disabled: .blackOpacity(.black15))
        }
    }
    
    private func setupHierarchy() {
        addSubviews(
            titleLabel,
            subTitleLabel,
            nicknameTextField,
            checkDuplicateButton,
            nicknameRulesLabel,
            nextButton
        )
    }
    
}
