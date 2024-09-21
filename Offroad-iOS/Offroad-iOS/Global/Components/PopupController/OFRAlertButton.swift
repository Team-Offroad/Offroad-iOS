//
//  OFRAlertButton.swift
//  Offroad-iOS
//
//  Created by 김민성 on 9/12/24.
//

import UIKit

class OFRAlertButton: UIButton {
    
    //MARK: - Properties
    
    var action: OFRAlertAction
    
    //MARK: - Life Cycle
    
    init(alertAction: OFRAlertAction) {
        self.action = alertAction
        super.init(frame: .zero)
        
        setupStyle()
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
    
    //MARK: - Private Func
    
    private func setupStyle() {
        setupStyle(of: .default)
    }
    
    private func setupStyle(of style: OFRAlertAction.Style) {
        
        roundCorners(cornerRadius: 5)
        
        let normalBackground: UIColor
        var highlightedBackgroundColor: UIColor {
            // 추후 디자인 팀과 논의하여 highlight 상태일 경우 색을 별도로 요청할 생각입니다.
            return normalBackground.withAlphaComponent(0.9)
        }
        let disabledBackground: UIColor = UIColor.lightGray
        
        titleLabel?.font = .offroad(style: .iosBtnSmall)
        switch style {
        case .default:
            normalBackground = .main(.main2)
            setTitleColor(.primary(.white), for: .normal)
            
        case .cancel:
            normalBackground = .main(.main3)
            setTitleColor(.main(.main2), for: .normal)
            setTitleColor(.main(.main2), for: .highlighted)
            layer.borderColor = UIColor.main(.main2).cgColor
            layer.borderWidth = 1
            clipsToBounds = true
            
        case .destructive:
            normalBackground = .main(.main3)
            setTitleColor(.main(.main2), for: .normal)
            layer.borderColor = UIColor.main(.main2).cgColor
            layer.borderWidth = 1
            clipsToBounds = true
        }
        
        var configuration = UIButton.Configuration.filled()
        
        let colorTransformer = UIConfigurationColorTransformer { [weak self] incomingColor in
            let outgoingColor: UIColor
            
            if self?.state == .normal {
                outgoingColor = normalBackground
            } else if self?.state == .highlighted {
                outgoingColor = highlightedBackgroundColor
            } else if self?.state == .disabled {
                outgoingColor = disabledBackground
            } else {
                outgoingColor = normalBackground
            }
            return outgoingColor
        }
        
        configuration.background.backgroundColorTransformer = colorTransformer
        self.configuration = configuration
    }
    
    private func setupButtonAction(_ action: OFRAlertAction) {
        setTitle(action.title, for: .normal)
        setupStyle(of: action.style)
    }
    
}
