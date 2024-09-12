//
//  OFRPopupView.swift
//  Offroad-iOS
//
//  Created by 김민성 on 9/12/24.
//

import UIKit

enum PopupViewRatio {
    case vertical
    case horizontal
    case square
}

class OFRPopupView: UIView {
    
    //MARK: - Properties
    
    var ratio: PopupViewRatio = .horizontal
    
    var title: String?
    var message: String?
    var actions: [UIAction] = []
    
    var horizontalInset: CGFloat = 46
    var verticalInset: CGFloat {
        switch ratio {
        case .vertical:
            return 38
        case .horizontal, .square:
            return 28
        }
    }
    
    //MARK: - UI Properties
    
    let contentView = UIView()
    
    let closeButton = UIButton()
    let titleLabel = UILabel()
    let descriptionLabel = UILabel()
    
    var buttons: [UIButton] = []
    
    lazy var buttonStackView: UIStackView = UIStackView(arrangedSubviews: buttons)
    
    //MARK: - Life Cycle
    
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

extension OFRPopupView {
    
    //MARK: - Layout
    
    private func setupLayout() {
        closeButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(12)
            make.size.equalTo(44)
        }
        
        contentView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(horizontalInset)
            make.verticalEdges.equalToSuperview().inset(verticalInset)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }
        
        descriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(18)
            make.horizontalEdges.equalToSuperview()
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(descriptionLabel.snp.bottom).offset(18)
            make.horizontalEdges.bottom.equalToSuperview()
        }
    }
    
    //MARK: - @objc Func
    
    //MARK: - Private Func
    
    private func setupStyle() {
        /*
         popupView 투명도의 초깃값을 0으로 설정.
         팝업 애니메이션이 젹용되면서 투명도를 1로 설정.
         */
        alpha = 0
        backgroundColor = .main(.main3)
        roundCorners(cornerRadius: 15)
        
        // 이미지 에셋 폴더 및 파일 정리하기
        closeButton.do { button in
            button.setImage(.iconClose, for: .normal)
        }
        
        titleLabel.do { label in
            label.font = .offroad(style: .iosTextTitle)
            label.textColor = .main(.main2)
        }
        
        descriptionLabel.do { label in
            label.font = .offroad(style: .iosTextRegular)
            label.textColor = .main(.main2)
            label.setLineSpacing(spacing: <#T##CGFloat#>)
        }
        
        
        buttonStackView.do { stackView in
            stackView.axis = buttons.count <= 2 ? .horizontal : .vertical
            stackView.spacing = 14
            stackView.alignment = .fill
            stackView.distribution = .equalSpacing
        }
    }
    
    private func setupHierarchy() {
        addSubviews(contentView, closeButton)
        contentView.addSubviews(
            titleLabel,
            descriptionLabel,
            buttonStackView
        )
    }
    
    //MARK: - Func
    
}
