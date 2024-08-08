//
//  CustomSegmentedControlType.swift
//  Offroad-iOS
//
//  Created by 김민성 on 8/3/24.
//

import UIKit

protocol CustomSegmentedControlType: AnyObject {
    
    associatedtype ConcreteType: UIView
    
    init(titles: [String])
    
    var underbarLeadingConstraint: NSLayoutConstraint { get set }
    var underbarTrailingConstraint: NSLayoutConstraint { get set }
    
    var underbar: UIView { get }
    
    func updateSegmentState(selectedIndex: Int)
    func setUnderbarPosition(to: Int)
    
}



extension CustomSegmentedControlType where Self: UIStackView {
    
    /// 각 버튼의 상태를 변경하는 함수
    /// - Parameter selectedIndex: 선택할 인덱스
    func updateSegmentState(selectedIndex: Int) {
        //선택함 버튼 텍스트의 색깔만 굵게 설정
        self.arrangedSubviews.forEach { view in
            let button = view as! UIButton
            button.isSelected = (button.tag == selectedIndex)
        }
        
        // 언더바 위치 설정하는 애니메이션 설정
        let animator = UIViewPropertyAnimator(duration: 0.3, dampingRatio: 1)
        animator.addAnimations { [unowned self] in
            self.setUnderbarPosition(to: selectedIndex)
        }
        animator.startAnimation()
    }
    
    /// 언더바 constraints 위치를 특정  index에 맞게 설정
    /// - Parameter index: underbar가 위치할 index
    func setUnderbarPosition(to index: Int) {
        guard let selectedButton = self.arrangedSubviews[index] as? UIButton else { fatalError() }
        self.underbarLeadingConstraint.constant = selectedButton.frame.origin.x
        self.underbarTrailingConstraint.constant = selectedButton.frame.origin.x + selectedButton.bounds.width
        self.layoutIfNeeded() // 애니메이션 구현하기 위함
    }
    
}
