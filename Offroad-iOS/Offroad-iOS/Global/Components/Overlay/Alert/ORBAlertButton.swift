//
//  ORBAlertButton.swift
//  Offroad-iOS
//
//  Created by 김민성 on 9/12/24.
//

import UIKit

class ORBAlertButton: ShrinkableButton {
    
    //MARK: - Properties
    
    var action: ORBAlertAction
    
    //MARK: - Life Cycle
    
    init(alertAction: ORBAlertAction) {
        self.action = alertAction
        super.init(shrinkScale: 0.97)
        
        setupStyle()
        setupLayout()
        setupButtonAction(alertAction)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension ORBAlertButton {
    
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
    
    private func setupStyle(of style: ORBAlertAction.Style) {
        
        roundCorners(cornerRadius: 5)
        
        let normalBackground: UIColor
        var highlightedBackgroundColor: UIColor {
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
    
    private func setupButtonAction(_ action: ORBAlertAction) {
        setTitle(action.title, for: .normal)
        setupStyle(of: action.style)
    }
    
}
