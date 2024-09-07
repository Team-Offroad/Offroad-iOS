//
//  StateToggleButton.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 7/11/24.
//

import UIKit

enum buttonState {
    case isEnabled
    case isDisabled
}

/// Offroad Custom Button
/// 활성화 상태에 따라 정해진 레이아웃을 가진 button으로 설정할 수 있음
/// - Parameter state: button의 활성화 여부
/// - Parameter title: button의 title에 들어갈 문구
/// > 사용 예시 :  `private let button: StateToggleButton = StateToggleButton(state: .isEnabled, title: "다음")`
final class StateToggleButton: UIButton {
    
    // MARK: - Life Cycle

    init(state: buttonState, title: String) {
        super.init(frame: .zero)
        
        setupStyle(forState: state, forTitle: title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension StateToggleButton {
    
    // MARK: - Private Func

    private func setupStyle(forState: buttonState, forTitle: String) {
        switch forState {
        case .isEnabled:
            backgroundColor = .main(.main2)
            setTitleColor(UIColor.primary(.white), for: .normal)
            isEnabled = true
        case .isDisabled:
            backgroundColor = .blackOpacity(.black15)
            layer.borderColor = UIColor.blackOpacity(.black15).cgColor
            setTitleColor(UIColor.primary(.white), for: .normal)
            isEnabled = false
        }
        roundCorners(cornerRadius: 5)
        setTitle(forTitle, for: .normal)
        titleLabel?.font = .offroad(style: .iosTextRegular)
    }
    
    func changeState(forState: buttonState) {
        switch forState {
        case .isEnabled:
            backgroundColor = .main(.main2)
            isEnabled = true
        case .isDisabled:
            backgroundColor = .blackOpacity(.black15)
            isEnabled = false
        }
    }
}
