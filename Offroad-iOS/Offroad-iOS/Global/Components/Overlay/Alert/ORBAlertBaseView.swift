//
//  ORBAlertBaseView.swift
//  Offroad-iOS
//
//  Created by 김민성 on 10/19/24.
//

import UIKit

class ORBAlertBaseView: UIView {
    
    //MARK: - Properties
    
//    private var ratio: OFRAlertViewRatio = .horizontal
//    var type: OFRAlertType
    
    var title: String? {
        didSet { self.titleLabel.text = title }
    }
    
    var message: String? {
        didSet { self.messageLabel.text = message }
    }
    
//    var subMessage: String? {
//        didSet { self.subMessageLabel.text = subMessage }
//    }
    
//    private var topInset: CGFloat {
//        switch type {
//        case .normal, .textField, .textFieldWithSubMessage, .custom:
//            28
//        case .scrollableContent, .explorationResult, .acquiredEmblem:
//            38
//        }
//    }
//
//    private var leftInset: CGFloat {
//        switch type {
//        case .normal, .textField, .textFieldWithSubMessage, .scrollableContent, .explorationResult, .custom:
//            46
//        case .acquiredEmblem:
//            24
//        }
//    }
//
//    private var rightInset: CGFloat {
//        switch type {
//        case .normal, .textField, .textFieldWithSubMessage, .scrollableContent, .explorationResult, .custom:
//            46
//        case .acquiredEmblem:
//            24
//        }
//    }
//
//    private var bottomInset: CGFloat {
//        switch type {
//        case .normal, .textField, .textFieldWithSubMessage, .custom:
//            28
//        case .scrollableContent, .explorationResult:
//            38
//        case .acquiredEmblem:
//            20
//        }
//    }
    
    var actions: [OFRAlertAction] = [] {
        didSet {
            buttons = actions.map({ action in
                let button = OFRAlertButton(alertAction: action)
                return button
            })
        }
    }
    
    //MARK: - UI Properties
    
//    lazy var contentView: UIView = {
//        switch type {
//        case .normal:
//            UIStackView(arrangedSubviews: [titleLabel,
//                                           spacerView1,
//                                           messageLabel,
//                                           spacerView2,
//                                           buttonStackView])
//            .then { stackView in
//                stackView.axis = .vertical
//                stackView.alignment = .fill
//                stackView.distribution = .fill
//            }
//        default:
//            UIView()
//        }
//    }()
    
    let closeButton = UIButton()
    let titleLabel = UILabel()
    let messageLabel = UILabel()
    
    private(set) var buttons: [OFRAlertButton] = [] {
        didSet {
            print("현재 버튼의 수: \(buttons.count)")
            //buttonStackView = UIStackView(arrangedSubviews: [])
            guard let addedButton = buttons.last else { return }
            buttonStackView.addArrangedSubview(addedButton)
        }
    }
    
    lazy var buttonStackView: UIStackView = UIStackView(arrangedSubviews: buttons)
    
    //MARK: - Life Cycle
    
//    init(type: OFRAlertType) {
//        self.type = type
//        super.init(frame: .zero)
//        
//        setupStyle()
//        setupHierarchy()
//        setupLayout()
//    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//}
//
//extension ORBAlertBaseView {
    
    func setupStyle() {
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
        
//        defaultTextField.do { textField in
//            textField.font = .offroad(style: .iosHint)
//            textField.textColor = .primary(.black)
//            textField.backgroundColor = .main(.main3)
//            textField.layer.borderColor = UIColor.grayscale(.gray200).cgColor
//            textField.layer.borderWidth = 1
//            textField.clipsToBounds = true
//            textField.roundCorners(cornerRadius: 5)
//            textField.addPadding(left: 12, right: 12)
//        }
        
        buttonStackView.do { stackView in
            stackView.axis = buttons.count <= 2 ? .horizontal : .vertical
            stackView.spacing = 14
            stackView.alignment = .fill
            stackView.distribution = .fillEqually
        }
    }
    
    func setupHierarchy() { }
    func setupLayout() {
        closeButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(12)
            make.size.equalTo(44)
        }        
    }
    
}
