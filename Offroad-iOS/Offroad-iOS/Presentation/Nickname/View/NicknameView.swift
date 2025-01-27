//
//  NicknameView.swift
//  Offroad-iOS
//
//  Created by  정지원 on 7/9/24.
//

import UIKit

import SnapKit
import Then

final class NicknameView: UIView {
    
    //MARK: - Properties
    
    private let mainLabel = UILabel().then {
        $0.text = "모험가 프로필 작성"
        $0.textAlignment = .center
        $0.textColor = UIColor.main(.main2)
        $0.font = UIFont.offroad(style: .iosProfileTitle)
    }
    
    private let subLabel = UILabel().then {
        $0.text = "어떤 이름으로 불러드릴까요?"
        $0.textAlignment = .center
        $0.textColor = UIColor.main(.main2)
        $0.font = UIFont.offroad(style: .iosSubtitleReg)
    }
    
    var nicknameTextField = UITextField().then {
        $0.textColor = UIColor.main(.main2)
        $0.backgroundColor = UIColor.main(.main3)
        $0.addPadding(left: 13,right: 13)
        $0.layer.borderWidth = 1.0
        $0.roundCorners(cornerRadius: 5)
        $0.layer.borderColor = UIColor.grayscale(.gray100).cgColor
        $0.attributedPlaceholder = NSAttributedString(
            string: "닉네임 입력",
            attributes: [NSAttributedString.Key.font: UIFont.offroad(style: .iosTextAuto), NSAttributedString.Key.foregroundColor: UIColor.grayscale(.gray300)]
        )
        $0.resignFirstResponder()
    }
    
    let checkButton = ShrinkableButton().then {
        $0.setTitle("중복확인", for: .normal)
        $0.titleLabel?.textAlignment = .center
        $0.titleLabel?.font = UIFont.offroad(style: .iosBtnSmall)
        $0.setTitleColor(UIColor.primary(.white), for: .normal)
        $0.backgroundColor = UIColor.blackOpacity(.black15)
        $0.roundCorners(cornerRadius: 5)
        $0.isEnabled = false
    }
    
    private let textFieldStackView = UIStackView().then {
        $0.axis = .horizontal
        $0.alignment = .fill
        $0.spacing = 14
        $0.distribution = .fillProportionally
    }
    
    let notionLabel = UILabel().then {
        $0.text = "*한글 2~8자, 영어 2~16자 이내로 작성해주세요."
        $0.textColor = UIColor.grayscale(.gray400)
        $0.font = UIFont.offroad(style: .iosHint)
    }
    
    let nextButton = StateToggleButton(state: .isDisabled, title: "다음")

    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension NicknameView {
    
    // MARK: - Private Func
    
    private func setupHierarchy() {
        addSubviews(
            mainLabel,
            subLabel,
            textFieldStackView,
            notionLabel,
            nextButton
        )

        textFieldStackView.addArrangedSubviews(nicknameTextField, checkButton)
    }
    
    private func setupLayout() {
        
        mainLabel.snp.makeConstraints{ make in
            make.top.equalTo(safeAreaLayoutGuide).offset(97)
            make.leading.trailing.equalToSuperview().inset(63)
        }
        
        subLabel.snp.makeConstraints{ make in
            make.top.equalTo(mainLabel.snp.bottom).offset(12)
            make.leading.trailing.equalToSuperview().inset(63)
        }
        
        textFieldStackView.snp.makeConstraints { make in
            make.top.equalTo(subLabel.snp.bottom).offset(64)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(48)
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.leading.equalTo(textFieldStackView)
            make.height.equalTo(48)
        }
        
        checkButton.snp.makeConstraints { make in
            make.trailing.equalTo(textFieldStackView)
            make.height.equalTo(48)
            make.width.equalTo(90)
        }
        
        notionLabel.snp.makeConstraints { make in
            make.top.equalTo(textFieldStackView.snp.bottom).offset(12)
            make.leading.equalToSuperview().inset(24)
        }
        
        nextButton.snp.makeConstraints { make in
            make.bottom.equalTo(safeAreaLayoutGuide).inset(24)
            make.leading.trailing.equalToSuperview().inset(24)
            make.height.equalTo(54)
        }
    }
}
