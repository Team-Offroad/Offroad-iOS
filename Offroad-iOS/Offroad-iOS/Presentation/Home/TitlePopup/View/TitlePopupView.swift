//
//  TitlePopupView.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 7/11/24.
//

import UIKit

import SnapKit
import Then

final class TitlePopupView: UIView {
    
    //MARK: - Properties
    
    typealias ButtonAction = () -> Void

    private var buttonAction: ButtonAction?

    //MARK: - UI Properties
    
    private let myTitleLabel = UILabel()
    private let closeButton = UIButton()
    private let titleTableView = UITableView()
    private let changeTitleButton = UIButton()
        
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

extension TitlePopupView {
    
    // MARK: - Layout
    
    private func setupStyle() {
        backgroundColor = .main(.main3)
        roundCorners(cornerRadius: 15)
        
        myTitleLabel.do {
            $0.text = "내가 모은 칭호"
            $0.textAlignment = .center
            $0.textColor = .main(.main2)
            $0.font = .offroad(style: .iosTextTitle)
        }
        
        closeButton.do {
//            $0.setImage(UIImage(resource: .), for: <#T##UIControl.State#>)
            $0.backgroundColor = .lightGray
        }
        
        titleTableView.do {
            $0.backgroundColor = .lightGray
        }
        
        changeTitleButton.do {
            $0.setTitle("바꾸기", for: .normal)
            $0.setTitleColor(.primary(.white), for: .normal)
            $0.backgroundColor = .sub(.sub4)
            $0.roundCorners(cornerRadius: 5)
        }
    }
    
    private func setupHierarchy() {
        addSubviews(
            myTitleLabel,
            closeButton,
            titleTableView,
            changeTitleButton
        )
    }
    
    private func setupLayout() {
        myTitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(32)
        }
        
        closeButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(13)
            $0.trailing.equalToSuperview().inset(12)
            $0.height.width.equalTo(44)
        }
        
        titleTableView.snp.makeConstraints {
            $0.top.equalTo(myTitleLabel.snp.bottom).offset(32)
            $0.leading.equalToSuperview().inset(24)
            $0.trailing.equalToSuperview().inset(12)
            $0.bottom.equalTo(changeTitleButton.snp.top).offset(-12)
        }
        
        changeTitleButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(20)
            $0.height.equalTo(54)
        }
    }
    
    //MARK: - @Objc
    
    @objc private func buttonTapped() {
        buttonAction?()
    }
    
    //MARK: - targetView Method
    
    func setupButton(action: @escaping ButtonAction) {
        buttonAction = action
//        button.addTarget(self, action: #selector(buttonTapped), for: .touchUpInside)
    }
}
