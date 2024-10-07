//
//  OFRAlertView.swift
//  Offroad-iOS
//
//  Created by 김민성 on 9/12/24.
//

import UIKit

/// 팝업 뷰의 화면비
enum OFRAlertViewRatio {
    
    /// 팝업 뷰의 세로 길이가 가로 길이보다 더 긴 경우
    case vertical
    
    /// 팝업 뷰의 가로 길이가 세로 길이보다 더 긴 경우
    case horizontal
    
    /// 정사각형 모양인 경우
    case square
}


/// 팝업 뷰의 종류
enum OFRAlertViewType {
    
    /**
     제목, 메시지, 버튼만 존재하는 가장 기본적인 형태의 팝업 타입
     */
    case normal
    
    /**
     팝업 내에 text field가 들어가는 타입.  
     text field의 위치는 button 바로 상단에 위치하며,
     text field의 위치를 다른 곳에 배치하고 싶을 경우,
     ''custom' case를 선택한 후, 직접 설정
     */
    case textField
    
    /**
     스크롤 가능한 컨텐츠를 포함하는 경우
     */
    case scrollableContent
    
    /**
     메시지와 버튼 사이의 뷰를 커스텀 뷰로 채워넣는 경우.
     */
    case custom
}

class OFRAlertView: UIView {
    
    //MARK: - Properties
    
    private var ratio: OFRAlertViewRatio = .horizontal
    
    private(set) var title: String? {
        didSet { self.titleLabel.text = title }
    }
    
    private(set) var message: String? {
        didSet { self.messageLabel.text = message }
    }
    
    private var horizontalInset: CGFloat = 46
    private var verticalInset: CGFloat {
        switch ratio {
        case .vertical:
            return 38
        case .horizontal, .square:
            return 28
        }
    }
    
    var actions: [OFRAlertAction] = [] {
        didSet {
            buttons = actions.map({ action in
                let button = OFRAlertButton(alertAction: action)
                return button
            })
        }
    }
    
    //MARK: - UI Properties
    
    private let contentView = UIView()
    
    let closeButton = UIButton()
    let titleLabel = UILabel()
    let messageLabel = UILabel()
    
    private(set) var defaultTextField = UITextField()
    
    private(set) var buttons: [OFRAlertButton] = [] {
        didSet {
            print("현재 버튼의 수: \(buttons.count)")
            //buttonStackView = UIStackView(arrangedSubviews: [])
            guard let addedButton = buttons.last else { return }
            buttonStackView.addArrangedSubview(addedButton)
        }
    }
    
    private lazy var buttonStackView: UIStackView = UIStackView(arrangedSubviews: buttons)
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupDefaultStyle()
        setupDefaultHierarchy()
        setupDefaultLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}

extension OFRAlertView {
    
    //MARK: - Layout
    
    private func setupDefaultLayout() {
        closeButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(12)
            make.size.equalTo(44)
        }
        
        contentView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(horizontalInset)
            make.verticalEdges.equalToSuperview().inset(verticalInset)
            make.height.greaterThanOrEqualTo(184)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
        }
        titleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
        
        messageLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview()
        }
        
        buttonStackView.snp.makeConstraints { make in
            make.top.greaterThanOrEqualTo(messageLabel.snp.bottom).offset(18)
            make.horizontalEdges.bottom.equalToSuperview()
            make.height.equalTo(44)
        }
    }
    
    private func setupLayout(of type: OFRAlertViewType) {
        
        switch type {
        case .normal:
            messageLabel.snp.makeConstraints { make in
                make.bottom.equalTo(buttonStackView.snp.top).offset(-24)
            }
            
        case .textField:
            defaultTextField.snp.makeConstraints { make in
                make.top.equalTo(messageLabel.snp.bottom).offset(10)
                make.horizontalEdges.equalToSuperview()
                make.bottom.equalTo(buttonStackView.snp.top).offset(-18)
                make.height.equalTo(43)
            }
            
        case .scrollableContent:
            return
        case .custom:
            return
        }
        
    }
    
    //MARK: - Private Func
    
    private func setupDefaultStyle() {
        /*
         AlertView 투명도의 초깃값을 0으로 설정.
         팝업 애니메이션이 젹용되면서 투명도를 1로 설정.
         */
        alpha = 0
        backgroundColor = .main(.main3)
        roundCorners(cornerRadius: 15)
        
        closeButton.do { button in
            button.setImage(.iosOfrAlertXmark, for: .normal)
        }
        
        titleLabel.do { label in
            label.font = .offroad(style: .iosTextTitle)
            label.textColor = .main(.main2)
            label.textAlignment = .center
        }
        
        messageLabel.do { label in
            label.font = .offroad(style: .iosTextRegular)
            label.textColor = .main(.main2)
            label.textAlignment = .center
            label.numberOfLines = 0
            label.setLineHeight(percentage: 150)
        }
        
        defaultTextField.do { textField in
            textField.font = .offroad(style: .iosHint)
            textField.textColor = .primary(.black)
            textField.backgroundColor = .main(.main3)
            textField.layer.borderColor = UIColor.grayscale(.gray200).cgColor
            textField.layer.borderWidth = 1
            textField.clipsToBounds = true
            textField.roundCorners(cornerRadius: 5)
            textField.addPadding(left: 12, right: 12)
        }
        
        buttonStackView.do { stackView in
            stackView.axis = buttons.count <= 2 ? .horizontal : .vertical
            stackView.spacing = 14
            stackView.alignment = .fill
            stackView.distribution = .fillEqually
        }
    }
    
    private func setupDefaultHierarchy() {
        addSubviews(contentView, closeButton)
        contentView.addSubviews(
            titleLabel,
            messageLabel,
            buttonStackView
        )
    }
    
    private func setupHierarchy(of type: OFRAlertViewType) {
        switch type {
        case .normal:
            return
        case .textField:
            contentView.addSubview(defaultTextField)
        case .scrollableContent:
            return
        case .custom:
            return
        }
    }
    
    //MARK: - Func
    
    func setFinalLayout(of type: OFRAlertViewType) {
        // 순서 조심! view hierarchy -> constraint 순서로
        setupHierarchy(of: type)
        setupLayout(of: type)
    }
    
}
