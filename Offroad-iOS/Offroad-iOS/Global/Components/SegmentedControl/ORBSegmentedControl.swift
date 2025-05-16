//
//  ORBSegmentedControl.swift
//  Offroad-iOS
//
//  Created by 김민성 on 8/3/24.
//

import UIKit

import SnapKit

@objc protocol ORBSegmentedControlDelegate: AnyObject {
    @objc optional func segmentedControlDidSelect(segmentedControl: ORBSegmentedControl, selectedIndex: Int)
    @objc optional func segmentedControlWillSelect(segmentedControl: ORBSegmentedControl, selectedIndex: Int)
}

final class ORBSegmentedControl: UIView {
    
    //MARK: - Properties
    
    private let underbarAnimator = UIViewPropertyAnimator(duration: 0, dampingRatio: 1)
    private lazy var underbarLeadingConstraint = underbar.leadingAnchor.constraint(equalTo: leadingAnchor)
    private var segmentWidth: CGFloat { frame.width / CGFloat(titles.count) }
    var segmentsCount: Int { stackView.arrangedSubviews.count }
    
    private(set) var titles: [String]
    private(set) var selectedIndex: Int = 0
    weak var delegate: ORBSegmentedControlDelegate? = nil
    
    //MARK: - UI Properties
    
    private let stackView: UIStackView
    private let underbar = UIView()
    
    //MARK: - Life Cycle
    
    init(titles: [String]) {
        self.titles = titles
        let buttonsArray = titles.enumerated().map { (index, title) in
            ORBSegmentedControlButton(title: title, tag: index)
        }
        stackView = UIStackView(arrangedSubviews: buttonsArray)
        super.init(frame: .zero)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        setButtonsTarget()
        updateButtonSelectedState(selectedIndex: 0)
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// Initial Settings
private extension ORBSegmentedControl {
    
    func setupStyle() {
        stackView.do { stackView in
            stackView.axis = .horizontal
            stackView.distribution = .fillEqually
            stackView.spacing = 0
        }
        underbar.backgroundColor = .sub(.sub)
    }
    
    func setupHierarchy() {
        addSubviews(stackView, underbar)
    }
    
    func setupLayout() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        underbarLeadingConstraint.isActive = true
        underbar.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.height.equalTo(3)
            make.width.equalTo(self.snp.width).dividedBy(titles.count)
        }
    }
    
    func setButtonsTarget() {
        stackView.arrangedSubviews.forEach { view in
            guard let button = view as? ORBSegmentedControlButton else { return }
            button.addTarget(self, action: #selector(buttonDidSelected(sender:)), for: .touchUpInside)
        }
    }
    
    //MARK: @objc Func
    
    @objc func buttonDidSelected(sender: UIButton) {
        selectSegment(index: sender.tag)
    }
    
}

// underbar 위치 설정 관련 private 함수들.
private extension ORBSegmentedControl {
    
    /// 화면상에서 특정한 거리만큼 underbar의 위치를 업데이트하는 함수. 선택한 offset 값에 맞게 애니메이션이 적용됨.
    /// - Parameters:
    ///   - offset: underbar가 leading edge로부터 떨어져 있을 값.
    ///   - completion: 애니메이션이 완료된 후 호출되는 콜백 함수.
    func animateUnderbarPosition(offset: CGFloat, completion: ((UIViewAnimatingPosition) -> Void)? = nil) {
        // 손쉬운 사용>동작>동작 줄이기 항목을 킨 경우 애니메이션 미적용함.
        guard !UIAccessibility.isReduceMotionEnabled else {
            underbarLeadingConstraint.constant = offset
            layoutIfNeeded()
            return
        }
        
        underbarAnimator.stopAnimation(true)
        underbarAnimator.addAnimations { [weak self] in
            self?.underbarLeadingConstraint.constant = offset
            self?.layoutIfNeeded()
        }
        underbarAnimator.addCompletion { completion?($0) }
        underbarAnimator.startAnimation()
    }
    
    /// 특정한 index에 underbar가 위치하도록 underbar의 위치를 업데이트하는 함수. 선택한 index에 맞는 segment로 underbar 가 이동하는 애니메이션이 적용됨.
    /// - Parameters:
    ///   - index: underbar가 위치할 segment의 index
    ///   - completion: 애니메이션이 완료된 후 호출되는 콜백 함수.
    func animateUnderbarPosition(to index: Int, completion: ((UIViewAnimatingPosition) -> Void)? = nil) {
        let offset = CGFloat(index) * segmentWidth
        animateUnderbarPosition(offset: offset, completion: { completion?($0) })
    }
    
    /// 특정 segment가 선택됨에 따라 버튼들의 selected 상태를 업데이트 하는 함수.
    /// - Parameter selectedIndex: 선택된 segment의 index
    func updateButtonSelectedState(selectedIndex: Int) {
        stackView.arrangedSubviews.forEach { view in
            let button = view as! UIButton
            button.isSelected = (button.tag == selectedIndex)
        }
    }
    
}

// segment 선택, underbar 위치 설정 관련 internal 함수들.
extension ORBSegmentedControl {
    
    /// 특정 segment를 선택하는 동작. selected segment가 바뀔 경우 선택 동작의 직전과 직후에 `delegate` 메서드가 호출됨.
    /// - Parameters:
    ///   - index: 선택할 segment
    ///   - completion: underbar가 이동하는 애니메이션이 완료된 후 호출되는 콜백 함수.
    func selectSegment(index: Int, completion: ((UIViewAnimatingPosition) -> Void)? = nil) {
        guard index != selectedIndex else { return }
        guard 0 <= index && index < segmentsCount else { return }
        delegate?.segmentedControlWillSelect?(segmentedControl: self, selectedIndex: index)
        selectedIndex = index
        updateButtonSelectedState(selectedIndex: index)
        animateUnderbarPosition(to: index) { completion?($0) }
        delegate?.segmentedControlDidSelect?(segmentedControl: self, selectedIndex: index)
    }
    
}

// Buttons title 설정 관련 함수들
extension ORBSegmentedControl {
    
    /// 특정 index의 segment 이름을 바꾸는 함수.
    /// - Parameters:
    ///   - index: 바꿀 segment의 index
    ///   - newTitle: 바꾸고자 하는 segment에 적용할 새 title
    func changeSegmentTitle(at index: Int, to newTitle: String) {
        guard let button = stackView.arrangedSubviews[index] as? ORBSegmentedControlButton else { return }
        button.setTitle(newTitle, for: .normal)
    }
    
}
