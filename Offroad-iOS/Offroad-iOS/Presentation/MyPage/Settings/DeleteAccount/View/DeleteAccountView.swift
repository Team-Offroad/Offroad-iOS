//
//  DeleteAccountView.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 9/3/24.
//

import UIKit

import SnapKit
import Then

final class DeleteAccountView: UIView {

    //MARK: - UI Properties
    
    let popupView = UIView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    let deleteAccountMessageLabel = UILabel()
    let deleteAccountMessageTextField = UITextField()
    private let deleteAccountMessageStackView = UIStackView()
    let cancleButton = UIButton()
    let deleteAccountButton = StateToggleButton(state: .isDisabled, title: "탈퇴")
    private let buttonStackView = UIStackView()
    private let mainStackView = UIStackView()

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

extension DeleteAccountView {
    
    // MARK: - Layout
    
    private func setupStyle() {
        backgroundColor = .blackOpacity(.black25)
        
        popupView.do {
            $0.backgroundColor = .main(.main3)
            $0.roundCorners(cornerRadius: 15)
            $0.alpha = 0
        }

        titleLabel.do {
            $0.text = "회원 탈퇴"
            $0.font = .offroad(style: .iosTextTitle)
            $0.textColor = .main(.main2)
            $0.textAlignment = .center
        }

        descriptionLabel.do {
            $0.text = "정말 탈퇴하시겠어요?\n탈퇴하신다면 아래 문구를 입력창에\n그대로 입력해주세요."
            $0.setLineSpacing(spacing: 6)
            $0.numberOfLines = 3
            $0.font = .offroad(style: .iosText)
            $0.textColor = .main(.main2)
            $0.textAlignment = .center
        }
        
        deleteAccountMessageLabel.do {
            $0.text = "오프로드 회원을 탈퇴하겠습니다."
            $0.setLineSpacing(spacing: 6)
            $0.font = .offroad(style: .iosTextBold)
            $0.textColor = .sub(.sub2)
            $0.textAlignment = .center
        }
        
        deleteAccountMessageTextField.do {
            $0.backgroundColor = .main(.main3)
            $0.layer.borderColor = UIColor.grayscale(.gray200).cgColor
            $0.layer.borderWidth = 1
            $0.roundCorners(cornerRadius: 5)
            $0.font = .offroad(style: .iosHint)
            $0.attributedPlaceholder = NSAttributedString(string: "상단의 문구를 그대로 입력해 주세요.", attributes: [.foregroundColor: UIColor.grayscale(.gray300), .font: UIFont.offroad(style: .iosHint)])
            $0.textColor = .main(.main2)
            $0.addPadding(left: 12)
        }
        
        deleteAccountMessageStackView.do {
            $0.axis = .vertical
            $0.spacing = 10
            $0.alignment = .center
        }

        cancleButton.do {
            $0.setTitle("취소", for: .normal)
            $0.setTitleColor(.main(.main2), for: .normal)
            $0.titleLabel?.font = .offroad(style: .iosBtnSmall)
            $0.backgroundColor = .clear
            $0.roundCorners(cornerRadius: 5)
            $0.layer.borderColor = UIColor.main(.main2).cgColor
            $0.layer.borderWidth = 1
        }

        buttonStackView.do {
            $0.axis = .horizontal
            $0.spacing = 14
            $0.distribution = .fillEqually
        }
        
        mainStackView.do {
            $0.axis = .vertical
            $0.spacing = 18
            $0.alignment = .center
        }
    }
    
    private func setupHierarchy() {
        addSubview(popupView)
        popupView.addSubviews(mainStackView, buttonStackView)
        deleteAccountMessageStackView.addArrangedSubviews(deleteAccountMessageLabel, deleteAccountMessageTextField)
        buttonStackView.addArrangedSubviews(cancleButton, deleteAccountButton)
        mainStackView.addArrangedSubviews(titleLabel, descriptionLabel, deleteAccountMessageStackView, buttonStackView)
    }
    
    private func setupLayout() {
        popupView.snp.makeConstraints {
            $0.height.equalTo(332)
            $0.width.equalToSuperview().inset(24)
            $0.center.equalToSuperview()
        }
        
        mainStackView.snp.makeConstraints {
            $0.center.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(46)
            $0.height.equalToSuperview().inset(27)
        }
        
        deleteAccountMessageTextField.snp.makeConstraints {
            $0.height.equalTo(46)
            $0.width.equalToSuperview()
        }
        
        deleteAccountMessageStackView.snp.makeConstraints {
            $0.width.equalToSuperview()
        }
        
        buttonStackView.snp.makeConstraints {
            $0.height.equalTo(48)
            $0.width.equalToSuperview()
        }
    }
    
    //MARK: - Func
    
    func presentPopupView() {
        popupView.executePresentPopupAnimation()
    }
    
    func dismissPopupView(completion: @escaping () -> Void) {
        backgroundColor = .clear
        popupView.executeDismissPopupAnimation { _ in
            completion()
        }
    }
}
