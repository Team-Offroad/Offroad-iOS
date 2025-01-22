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
    ///   - normal: `normal` 상태일 때 배경색
    ///   - highlighted: `highlighted` 상태일 때 배경색
    ///   - focused: `focused` 상태일 때 배경색
    ///   - selected: `selected` 상태일 때 배경색
    ///   - disabled: `disabled` 상태일 때 배경색
    ///   - highlightedAndSelected:`highlighted`와 `selected`가 중첩 상태일 때 배경색.
    ///   - disabledAndSelected: `disabled`와 `selected`가 중첩 상태일 때 배경색.
    /// - Description
    /// `normal`을 제외한 나머지 매개변수은 매개변수의 값이 `nil`일 경우 `normal`의 값이 할당됨.
    func configureBackgroundColorWhen(
        normal: UIColor,
        highlighted: UIColor? = nil,
        focused: UIColor? = nil,
        selected: UIColor? = nil,
        disabled: UIColor? = nil,
        highlightedAndSelected: UIColor? = nil,
        disabledAndSelected: UIColor? = nil
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
            case .init(rawValue: 5):
                return highlightedAndSelected ?? normal
            case .init(rawValue: 6):
                return disabledAndSelected ?? disabled ?? normal
            default:
                return normal
            }
        }
        newConfiguration.background.backgroundColorTransformer = transformer
        self.configuration = newConfiguration
    }
    
    /// `UIButton`의 `state`에 따른 `title`의 `font`를 설정하는 메서드.
    /// - Parameters:
    ///   - normal: `normal` 상태일 때 title의 폰트.
    ///   - highlighted: `highlighted` 상태일 때 title의 폰트.
    ///   - focused: `focused` 상태일 때 title의 폰트.
    ///   - selected: `selected` 상태일 때 title의 폰트.
    ///   - disabled: `disabled` 상태일 때 title의 폰트.
    ///   - highlightedAndSelected:`highlighted`와 `selected`가 중첩 상태일 때 title의 폰트.
    ///   - disabledAndSelected: `disabled`와 `selected`가 중첩 상태일 때 title의 폰트.
    /// - Description
    /// `normal`을 제외한 나머지 매개변수은 매개변수의 값이 `nil`일 경우 `normal`의 값이 할당됨.
    func configureTitleFontWhen(
        normal: UIFont,
        highlighted: UIFont? = nil,
        focused: UIFont? = nil,
        selected: UIFont? = nil,
        disabled: UIFont? = nil,
        highlightedAndSelected: UIFont? = nil,
        disabledAndSelected: UIFont? = nil
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
            case .init(rawValue: 5):
                outgoing.font = highlightedAndSelected ?? normal
            case .init(rawValue: 6):
                outgoing.font = disabledAndSelected ?? disabled ?? normal
            default:
                break
            }
            return outgoing
        }
        newConfiguration.titleTextAttributesTransformer = transformer
        self.configuration = newConfiguration
    }
    
}

