//
//  UIButton+.swift
//  Offroad-iOS
//
//  Created by  정지원 on 7/10/24.
//

import UIKit

extension UIButton {
    
    //UIButton에 background를 상태에 따라 설정하는 함수
    //ex) button.setBackgroundColor(.black, for: .selected)
    /// - Parameter left: 버튼 배경 색상
    /// - Parameter right: 버튼의 상태
    func setBackgroundColor(_ color: UIColor, for state: UIControl.State) {
        UIGraphicsBeginImageContext(CGSize(width: 1.0, height: 1.0))
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setFillColor(color.cgColor)
        context.fill(CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0))

        let backgroundImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        setBackgroundImage(backgroundImage, for: state)
    }
    
    /// UIButton의 state에 따른 배경색을 설정하는 메서드
    /// - Parameters:
    ///   - normal: normal일 때의 font
    ///   - highlighted: highlighted 됐을 때의 배경색
    ///   - focused: focused 됐을 떄의 배경색
    ///   - selected: selected 됐을 때의 배경색
    ///   - disabled: disabled 됐을 떄의 배경색
    /// - Description
    /// normal을 제외한 나머지 매개변수은 매개변수의 값이 nil일 경우 normal의 값이 할당됨.
    func configureBackgroundColorWhen(
        normal: UIColor,
        highlighted: UIColor? = nil,
        focused: UIColor? = nil,
        selected: UIColor? = nil,
        disabled: UIColor? = nil
    ) {
        var newConfiguration: UIButton.Configuration
        if let configuration {
            newConfiguration = configuration
        } else {
            newConfiguration = UIButton.Configuration.gray()
        }
        
        let transformer = UIConfigurationColorTransformer { incomingColor in
            switch self.state {
            case .normal:
                return normal
            case .highlighted:
                return highlighted ?? normal
            case .focused:
                return focused ?? normal
            case .selected:
                return selected ?? normal
            case .disabled:
                return disabled ?? .gray
            default:
                return normal
            }
        }
        newConfiguration.background.backgroundColorTransformer = transformer
        self.configuration = newConfiguration
    }
    
    /// UIButton의 state에 따른 title의 font를 설정하는 메서드.
    /// - Parameters:
    ///   - normal: normal일 때의 폰트.
    ///   - highlighted: highlight 됐을 때의 폰트.
    ///   - focused: focused 됐을 때의 폰트.
    ///   - selected: selected 됐을 때의 폰트.
    ///   - disabled: disabled 됐을 때의 폰트.
    /// - Description
    /// normal을 제외한 나머지 매개변수은 매개변수의 값이 nil일 경우 normal의 값이 할당됨.
    func configureTitleFontWhen(
        normal: UIFont,
        highlighted: UIFont? = nil,
        focused: UIFont? = nil,
        selected: UIFont? = nil,
        disabled: UIFont? = nil
    ) {
        var newConfiguration: UIButton.Configuration
        if let configuration {
            newConfiguration = configuration
        } else {
            newConfiguration = UIButton.Configuration.gray()
        }
        
        let transformer = UIConfigurationTextAttributesTransformer { incoming in
            var outgoing = incoming
            switch self.state {
            case .normal:
                outgoing.font = normal
            case .highlighted:
                outgoing.font = highlighted ?? normal
            case .focused:
                outgoing.font = focused ?? normal
            case .selected:
                outgoing.font = selected ?? normal
            case .disabled:
                outgoing.font = disabled ?? normal
            default:
                break
            }
            return outgoing
        }
        newConfiguration.titleTextAttributesTransformer = transformer
        self.configuration = newConfiguration
    }
    
}

