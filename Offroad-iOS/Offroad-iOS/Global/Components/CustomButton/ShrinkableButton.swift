//
//  ShrinkableButton.swift
//  Offroad-iOS
//
//  Created by 김민성 on 1/5/25.
//

import UIKit

import RxSwift
import RxCocoa

class ShrinkableButton: UIButton, ORBTouchFeedback {
    
    //MARK: - Properties
    
    private var disposeBag = DisposeBag()
    private var shrinkScale: CGFloat
    
    /// 버튼의 isSelected가  true일 때 버튼에 손이 닿으면 shrink하는지 여부
    /// false로 설정할 경우, select되었을 때는 버튼에 손이 닿아도 (highlight되어도) shrink되지 않는다.
    var shrinkWhenSelected: Bool = true
    
    private(set) var shrinkingAnimator: UIViewPropertyAnimator = .init(duration: 0.15, curve: .easeOut)
    
    //MARK: - Life Cycle
    
    /// shrinkScale을 0.9로 설정
    ///
    /// `shrinkScale` 속성을 임의로 초기화하고 싶은 경우, 다른 지정생성자인 `init(shrinkScale:)`를 사용하세요.
    override init(frame: CGRect) {
        self.shrinkScale = 0.9
        super.init(frame: frame)
        
        setupActions()
    }
    
    /// `shrinkScale` 속성을 임의의 값으로 초기화하는 지정생성자
    /// - Parameter shrinkScale: 손가락이 버튼에 닿을 때 축소될 비율에 해당하는 속성. 다른 지정생성자인 `init(frame:)`를 사용하는 경우 0.9로 설정됨.
    init(shrinkScale: CGFloat) {
        self.shrinkScale = shrinkScale
        super.init(frame: .zero)
        
        setupActions()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func cancelTracking(with event: UIEvent?) {
        super.cancelTracking(with: event)
        
        restore()
    }
    
}

extension ShrinkableButton {
    
    //MARK: - Private Func
    
    private func setupActions() {
        self.rx.controlEvent(.touchDown).subscribe(onNext: { [weak self] in
            guard let self else { return }
            guard !self.isSelected || shrinkWhenSelected else { return }
            self.shrink(scale: self.shrinkScale)
        }).disposed(by: disposeBag)
        
        self.rx.controlEvent(.touchDragExit).subscribe(onNext: { [weak self] in
            guard let self else { return }
            self.cancelTracking(with: nil)
        }).disposed(by: disposeBag)
        
        self.rx.controlEvent(.touchUpInside).subscribe(onNext: { [weak self] in
            guard let self else { return }
            self.restore()
        }).disposed(by: disposeBag)
    }
    
}
