//
//  ORBAlertBaseView.swift
//  Offroad-iOS
//
//  Created by 김민성 on 10/19/24.
//

import UIKit

class ORBAlertBaseView: UIView {
    
    //MARK: - Properties
    
    var title: String? {
        didSet { self.titleLabel.text = title }
    }
    
    var message: String? {
        didSet { self.messageLabel.text = message }
    }
    
    var actions: [ORBAlertAction] = [] {
        didSet {
            buttons = actions.map({ action in
                let button = ORBAlertButton(alertAction: action)
                return button
            })
        }
    }
    
    //MARK: - UI Properties
    
    let closeButton = UIButton()
    let titleLabel = UILabel()
    let messageLabel = UILabel()
    
    private(set) var buttons: [ORBAlertButton] = [] {
        didSet {
            print("현재 버튼의 수: \(buttons.count)")
            guard let addedButton = buttons.last else { return }
            buttonStackView.addArrangedSubview(addedButton)
        }
    }
    
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
