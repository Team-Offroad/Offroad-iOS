//
//  OFRAlertButton.swift
//  Offroad-iOS
//
//  Created by 김민성 on 9/12/24.
//

import UIKit

class OFRAlertButton: UIButton {
    
    //MARK: - Properties
    
    var action: OFRAlertAction {
        didSet {
//            guard let primaryAction else { return }
//            setTitle(primaryAction.title, for: .normal)
//            setupStyle(of: primaryAction.style)
        }
    }
    
    //MARK: - UI Properties
    
    //MARK: - Life Cycle
    
    init(alertAction: OFRAlertAction) {
        self.action = alertAction
        super.init(frame: .zero)
        
        setupLayout()
        setupButtonAction(alertAction)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension OFRAlertButton {
    
    //MARK: - Layout
    
    private func setupLayout() {
        self.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
    }
    
    //MARK: - @objc Func
    
    //MARK: - Private Func
    
    private func setupStyle() {
        setupStyle(of: .default)
    }
    
    private func setupHierarchy() {
        
    }
    
    private func setupStyle(of style: OFRAlertAction.Style) {
        
        roundCorners(cornerRadius: 5)
        
        titleLabel?.font = .offroad(style: .iosBtnSmall)
        switch style {
        case .default:
            backgroundColor = .main(.main2)
            setTitleColor(.primary(.white), for: .normal)
            
        case .cancel:
            backgroundColor = .main(.main3)
            setTitleColor(.main(.main2), for: .normal)
            layer.borderColor = UIColor.main(.main2).cgColor
            layer.borderWidth = 1
            clipsToBounds = true
            
        case .destructive:
            backgroundColor = .main(.main3)
            setTitleColor(.main(.main2), for: .normal)
            layer.borderColor = UIColor.main(.main2).cgColor
            layer.borderWidth = 1
            clipsToBounds = true
        }
    }
    
    private func setupButtonAction(_ action: OFRAlertAction) {
        setTitle(action.title, for: .normal)
        setupStyle(of: action.style)
    }
    
    //MARK: - Func
    
}
