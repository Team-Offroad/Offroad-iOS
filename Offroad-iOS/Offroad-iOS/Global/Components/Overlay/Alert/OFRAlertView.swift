//
//  OFRAlertView.swift
//  Offroad-iOS
//
//  Created by 김민성 on 9/12/24.
//

import UIKit

import Then

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
enum OFRAlertType {
    
    /**
     제목, 설명, 버튼만 갖는 기본적인 형태/  345\*238
     */
    case normal
    
    /**
     텍스트 입력 창이 들어가는 형태
     text field의 위치는 button 바로 상단에 위치하며,
     text field의 위치를 다른 곳에 배치하고 싶을 경우,
     ''custom' case를 선택한 후, 직접 설정
     */
    case textField
    
    /**
     textField가 있으며 메시지 아래에 서브 텍스트가 있는 경우
     */
    case textFieldWithSubMessage
    
    /**
     팝업창 내 스크롤이 필요한 컨텐츠가 들어가는 형태/ 345\*544
     */
    case scrollableContent
    
    /**
     탐험 후 성패를 알려주는 팝업
     (피그마의 '성패 팝업')
     */
    case explorationResult
    
    /**
     홈 화면에서 칭호를 바꿀 시에 뜨는 팝업
     (피그마의 '내가 모은 칭호 팝업')
     */
    case acquiredEmblem
    
    /**
     메시지와 버튼 사이의 뷰를 커스텀 뷰로 채워넣는 경우.
     */
    case custom
}

class OFRAlertView: UIView {
    
    //MARK: - Properties
    
//    private var ratio: OFRAlertViewRatio = .horizontal
    private(set) var type: OFRAlertType
    
    private(set) var title: String? {
        didSet { self.titleLabel.text = title }
    }
    
    private(set) var message: String? {
        didSet { self.messageLabel.text = message }
    }
    
    private var subMessage: String? {
        didSet { self.subMessageLabel.text = subMessage }
    }
    
    private var topInset: CGFloat {
        switch type {
        case .normal, .textField, .textFieldWithSubMessage, .custom:
            28
        case .scrollableContent, .explorationResult, .acquiredEmblem:
            38
        }
    }
    
    private var leftInset: CGFloat {
        switch type {
        case .normal, .textField, .textFieldWithSubMessage, .scrollableContent, .explorationResult, .custom:
            46
        case .acquiredEmblem:
            24
        }
    }
    
    private var rightInset: CGFloat {
        switch type {
        case .normal, .textField, .textFieldWithSubMessage, .scrollableContent, .explorationResult, .custom:
            46
        case .acquiredEmblem:
            24
        }
    }
    
    private var bottomInset: CGFloat {
        switch type {
        case .normal, .textField, .textFieldWithSubMessage, .custom:
            28
        case .scrollableContent, .explorationResult:
            38
        case .acquiredEmblem:
            20
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
    
    private lazy var contentView: UIView = {
        switch type {
        case .normal:
            UIStackView(arrangedSubviews: [titleLabel,
                                           spacerView1,
                                           messageLabel,
                                           spacerView2,
                                           buttonStackView])
            .then { stackView in
                stackView.axis = .vertical
                stackView.alignment = .fill
                stackView.distribution = .fill
            }
        case .textField:
            UIView()
        default:
            UIView()
        }
    }()
    
    let closeButton = UIButton()
    let titleLabel = UILabel()
    let messageLabel = UILabel()
    let subMessageLabel = UILabel()
    
    private(set) var defaultTextField = UITextField()
    
    var scrollableContentView = UIView().then { scrollView in
        scrollView.backgroundColor = .clear
    }
    
    var explorationResultImageView = UIImageView()
    
    private(set) var buttons: [OFRAlertButton] = [] {
        didSet {
            print("현재 버튼의 수: \(buttons.count)")
            //buttonStackView = UIStackView(arrangedSubviews: [])
            guard let addedButton = buttons.last else { return }
            buttonStackView.addArrangedSubview(addedButton)
        }
    }
    
    private var spacerView1 = UIView()
    private var spacerView2 = UIView()
    
    private lazy var buttonStackView: UIStackView = UIStackView(arrangedSubviews: buttons)
    
    //MARK: - Life Cycle
    
    init(type: OFRAlertType) {
        self.type = type
        super.init(frame: .zero)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension OFRAlertView {
    
    //MARK: - Layout
    
    private func setupLayout() {
        switch type {
        case .normal:
            closeButton.snp.makeConstraints { make in
                make.top.trailing.equalToSuperview().inset(12)
                make.size.equalTo(44)
            }
            
            contentView.snp.makeConstraints { make in
                make.top.equalToSuperview().inset(topInset)
                make.leading.equalToSuperview().inset(leftInset)
                make.trailing.equalToSuperview().inset(rightInset)
                make.bottom.equalToSuperview().inset(bottomInset)
                make.height.greaterThanOrEqualTo(182)
            }
            
            titleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
            spacerView1.setContentHuggingPriority(.init(0), for: .vertical)
            spacerView2.setContentHuggingPriority(.init(0), for: .vertical)
            spacerView1.setContentCompressionResistancePriority(.init(999), for: .vertical)
            spacerView2.setContentCompressionResistancePriority(.init(999), for: .vertical)
            spacerView2.snp.makeConstraints { make in
                make.height.equalTo(spacerView1)
            }
        case .textField:
            closeButton.snp.makeConstraints { make in
                make.top.trailing.equalToSuperview().inset(12)
                make.size.equalTo(44)
            }
            
            contentView.snp.makeConstraints { make in
                make.top.equalToSuperview().inset(topInset)
                make.leading.equalToSuperview().inset(leftInset)
                make.trailing.equalToSuperview().inset(rightInset)
                make.bottom.equalToSuperview().inset(bottomInset)
                make.height.greaterThanOrEqualTo(182)
            }
            
            titleLabel.snp.makeConstraints { make in
                make.top.horizontalEdges.equalToSuperview()
                make.horizontalEdges.equalToSuperview()
            }
            titleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
            
            messageLabel.snp.makeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom).offset(18)
                make.horizontalEdges.equalToSuperview()
            }
            
            defaultTextField.snp.makeConstraints { make in
                make.top.equalTo(messageLabel.snp.bottom).offset(10)
                make.horizontalEdges.equalToSuperview()
                make.height.equalTo(43)
            }
            
            buttonStackView.snp.makeConstraints { make in
                make.top.equalTo(defaultTextField.snp.bottom).offset(18)
                make.horizontalEdges.equalToSuperview()
                make.bottom.equalToSuperview()
            }
            
        case .textFieldWithSubMessage:
            closeButton.snp.makeConstraints { make in
                make.top.trailing.equalToSuperview().inset(12)
                make.size.equalTo(44)
            }
            
            contentView.snp.makeConstraints { make in
                make.top.equalToSuperview().inset(topInset)
                make.leading.equalToSuperview().inset(leftInset)
                make.trailing.equalToSuperview().inset(rightInset)
                make.bottom.equalToSuperview().inset(bottomInset)
                make.height.greaterThanOrEqualTo(182)
            }
            
            titleLabel.snp.makeConstraints { make in
                make.top.horizontalEdges.equalToSuperview()
                make.horizontalEdges.equalToSuperview()
            }
            titleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
            
            messageLabel.snp.makeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom).offset(18)
                make.horizontalEdges.equalToSuperview()
            }
            
            subMessageLabel.snp.makeConstraints { make in
                make.top.equalTo(messageLabel.snp.bottom).offset(18)
                make.horizontalEdges.equalToSuperview()
            }
            
            defaultTextField.snp.makeConstraints { make in
                make.top.equalTo(subMessageLabel.snp.bottom).offset(10)
                make.horizontalEdges.equalToSuperview()
                make.height.equalTo(43)
            }
            
            buttonStackView.snp.makeConstraints { make in
                make.top.equalTo(defaultTextField.snp.bottom).offset(18)
                make.horizontalEdges.equalToSuperview()
                make.bottom.equalToSuperview()
            }
        case .scrollableContent:
            contentView.snp.makeConstraints { make in
                make.top.equalToSuperview().inset(topInset)
                make.leading.equalToSuperview().inset(leftInset)
                make.trailing.equalToSuperview().inset(rightInset)
                make.bottom.equalToSuperview().inset(bottomInset)
                make.height.greaterThanOrEqualTo(182)
            }
            
            titleLabel.snp.makeConstraints { make in
                make.top.horizontalEdges.equalToSuperview()
                make.horizontalEdges.equalToSuperview()
            }
            titleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
            
            scrollableContentView.snp.makeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom).offset(24)
                make.horizontalEdges.equalToSuperview()
                make.height.equalTo(350)
            }
            
            buttonStackView.snp.makeConstraints { make in
                make.top.equalTo(scrollableContentView.snp.bottom).offset(24)
                make.horizontalEdges.equalToSuperview()
                make.bottom.equalToSuperview()
            }
        case .explorationResult:
            contentView.snp.makeConstraints { make in
                make.top.equalToSuperview().inset(topInset)
                make.leading.equalToSuperview().inset(leftInset)
                make.trailing.equalToSuperview().inset(rightInset)
                make.bottom.equalToSuperview().inset(bottomInset)
                make.height.greaterThanOrEqualTo(182)
            }
            
            titleLabel.snp.makeConstraints { make in
                make.top.horizontalEdges.equalToSuperview()
                make.horizontalEdges.equalToSuperview()
            }
            titleLabel.setContentHuggingPriority(.defaultHigh, for: .vertical)
            
            messageLabel.snp.makeConstraints { make in
                make.top.equalTo(titleLabel.snp.bottom).offset(10)
                make.horizontalEdges.equalToSuperview()
            }
            
            explorationResultImageView.snp.makeConstraints { make in
                make.top.equalTo(messageLabel.snp.bottom)
                make.horizontalEdges.equalToSuperview()
                make.height.equalTo(182)
            }
            
            buttonStackView.snp.makeConstraints { make in
                make.top.equalTo(explorationResultImageView.snp.bottom)
                make.horizontalEdges.equalToSuperview()
                make.bottom.equalToSuperview()
            }
            
        default:
            closeButton.snp.makeConstraints { make in
                make.top.trailing.equalToSuperview().inset(12)
                make.size.equalTo(44)
            }
            
            contentView.snp.makeConstraints { make in
                make.top.equalToSuperview().inset(topInset)
                make.leading.equalToSuperview().inset(leftInset)
                make.trailing.equalToSuperview().inset(rightInset)
                make.bottom.equalToSuperview().inset(bottomInset)
                make.height.greaterThanOrEqualTo(182)
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
    }
    
//    private func setupLayout(of type: OFRAlertViewType) {
//        
//        switch type {
//        case .normal:
//            messageLabel.snp.makeConstraints { make in
//                make.bottom.equalTo(buttonStackView.snp.top).offset(-24)
//            }
//            
//        case .textField, .textFieldWithSubMessage:
//            defaultTextField.snp.makeConstraints { make in
//                make.top.equalTo(messageLabel.snp.bottom).offset(10)
//                make.horizontalEdges.equalToSuperview()
//                make.bottom.equalTo(buttonStackView.snp.top).offset(-18)
//                make.height.equalTo(43)
//            }
//            
//        case .scrollableContent:
//            return
//        case .explorationResult:
//            return
//        case .acquiredEmblem:
//            return
//        case .custom:
//            return
//        }
//        
//    }
    
    //MARK: - Private Func
    
    private func setupStyle() {
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
    
    private func setupHierarchy() {
        switch type {
        case .normal:
            addSubviews(contentView, closeButton)
        case .textField:
            addSubviews(contentView, closeButton)
            contentView.addSubviews(
                titleLabel,
                messageLabel,
                defaultTextField,
                buttonStackView
            )
        case .textFieldWithSubMessage:
            addSubviews(contentView, closeButton)
            contentView.addSubviews(
                titleLabel,
                messageLabel,
                subMessageLabel,
                defaultTextField,
                buttonStackView
            )
        case .scrollableContent:
            addSubviews(contentView, closeButton)
            contentView.addSubviews(titleLabel, scrollableContentView, buttonStackView)
        case .explorationResult:
            addSubviews(contentView)
            contentView.addSubviews(titleLabel, messageLabel, explorationResultImageView, buttonStackView)
        default:
            addSubviews(contentView, closeButton)
            contentView.addSubviews(
                titleLabel,
                messageLabel,
                buttonStackView
            )
        }
    }
    
//    private func setupHierarchy(of type: OFRAlertViewType) {
//        switch type {
//        case .normal:
//            return
//        case .textField, .textFieldWithSubMessage:
//            contentView.addSubview(defaultTextField)
//        case .scrollableContent:
//            return
//        case .explorationResult:
//            return
//        case .acquiredEmblem:
//            return
//        case .custom:
//            return
//        }
//    }
    
    //MARK: - Func
    
//    func setFinalLayout(of type: OFRAlertViewType) {
//        // 순서 조심! view hierarchy -> constraint 순서로
//        setupHierarchy(of: type)
//        setupLayout(of: type)
//    }
    
}
