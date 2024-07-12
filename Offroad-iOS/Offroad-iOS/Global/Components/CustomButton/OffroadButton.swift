//
//  OffroadButton.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 7/11/24.
//

import UIKit

enum offroadButtonState {
    case isEnabled
    case isdisabled
}

/// Offroad Custom Button
/// 활성화 상태에 따라 정해진 레이아웃을 가진 button으로 설정할 수 있음
/// - Parameter state: button의 활성화 여부
/// - Parameter title: button의 title에 들어갈 문구
/// > 사용 예시 :  `private let button: OffroadButton = OffroadButton(state: .isEnabled, title: "다음")`
final class OffroadButton: UIButton {
    
    // MARK: - Life Cycle

    init(state: offroadButtonState, title: String) {
        super.init(frame: .zero)
        
        setupStyle(forState: state, forTitle: title)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

extension OffroadButton {
    
    // MARK: - Private Func

    private func setupStyle(forState: offroadButtonState, forTitle: String) {
        switch forState {
        case .isEnabled:
            backgroundColor = .main(.main2)
            setTitleColor(.main(.main1), for: .normal)
            isEnabled = true
        case .isdisabled:
            backgroundColor = .blackOpacity(.black15)
            layer.borderColor = UIColor.blackOpacity(.black25).cgColor
            layer.borderWidth = 1
            setTitleColor(.grayscale(.gray400), for: .normal)
            isEnabled = false
        }
        roundCorners(cornerRadius: 5)
        setTitle(forTitle, for: .normal)
        titleLabel?.font = .offroad(style: .iosTextRegular)
    }
    
    func changeState(forState: offroadButtonState) {
        switch forState {
        case .isEnabled:
            backgroundColor = .main(.main2)
            setTitleColor(.main(.main1), for: .normal)
            isEnabled = true
        case .isdisabled:
            backgroundColor = .blackOpacity(.black15)
            layer.borderColor = UIColor.blackOpacity(.black25).cgColor
            layer.borderWidth = 1
            setTitleColor(.grayscale(.gray400), for: .normal)
            isEnabled = false
        }
    }
}
