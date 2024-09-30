//
//  OFRSegmentedControl.swift
//  Offroad-iOS
//
//  Created by 김민성 on 8/3/24.
//

import UIKit

import SnapKit

protocol OFRSegmentedControlDelegate: AnyObject {
    func segmentedControlDidSelected(segmentedControl: OFRSegmentedControl, selectedIndex: Int)
}

final class OFRSegmentedControl: UIView {
    
    //MARK: - Properties
    
    let animator = UIViewPropertyAnimator(duration: 0.3, dampingRatio: 1)
    weak var delegate: OFRSegmentedControlDelegate? = nil
    var titles: [String]
    var isLayoutDone: Bool = false
    
    private(set) var selectedIndex: Int = 0
    
    // underbar의 leading, trailing anchor의 제약을 담는 변수. 여기서 할당하는 값은 초깃값을 위한 값일 뿐이므로 의미 없음.
    lazy var underbarLeadingConstraint = underbar.leadingAnchor.constraint(equalTo: leadingAnchor)
    lazy var underbarTrailingConstraint = underbar.trailingAnchor.constraint(equalTo: trailingAnchor)
    
    //MARK: - UI Properties
    
    private let stackView: UIStackView
    private let underbar = UIView()
    
    //MARK: - Life Cycle
    
    init(titles: [String]) {
        self.titles = titles
        let buttonsArray = titles.enumerated().map { (index, title) in
            OFRSegmentedControlButton(title: title, tag: index)
        }
        self.stackView = UIStackView(arrangedSubviews: buttonsArray)
        super.init(frame: .zero)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        setButtonsTarget()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        isLayoutDone = true
        updateUnderbarPosition(to: selectedIndex)
        selectSegment(index: selectedIndex)
    }
    
}

extension OFRSegmentedControl {
    
    //MARK: @objc Func
    
    @objc private func segmentDidSelected(sender: UIButton) {
        guard sender.tag != selectedIndex else { return }
        selectSegment(index: sender.tag)
        delegate?.segmentedControlDidSelected(segmentedControl: self, selectedIndex: sender.tag)
    }
    
    //MARK: - Layout Func
    
    private func setupLayout() {
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        underbar.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.height.equalTo(3)
        }
    }
    
    //MARK: - Private Func
    
    private func setupStyle() {
        stackView.do { stackView in
            stackView.axis = .horizontal
            stackView.distribution = .fillEqually
            stackView.spacing = 0
        }
        underbar.backgroundColor = .sub(.sub)
    }
    
    private func setupHierarchy() {
        addSubviews(stackView, underbar)
    }
    
    private func setButtonsTarget() {
        stackView.arrangedSubviews.forEach { view in
            guard let button = view as? OFRSegmentedControlButton else { return }
            button.addTarget(self, action: #selector(segmentDidSelected(sender:)), for: .touchUpInside)
        }
    }
    
    private func updateUnderbarPosition(to index: Int) {
        let selectedButton = stackView.arrangedSubviews[index]
        animator.addAnimations { [unowned self] in
            self.underbarLeadingConstraint.isActive = false
            self.underbarTrailingConstraint.isActive = false
            
            self.underbarLeadingConstraint = underbar.leadingAnchor.constraint(equalTo: selectedButton.leadingAnchor)
            self.underbarTrailingConstraint = underbar.trailingAnchor.constraint(equalTo: selectedButton.trailingAnchor)
            self.underbarLeadingConstraint.isActive = true
            self.underbarTrailingConstraint.isActive = true
            self.layoutIfNeeded()
        }
        animator.startAnimation()
    }
    
    private func updateSegmentState(selectedIndex: Int) {
        stackView.arrangedSubviews.forEach { view in
            let button = view as! UIButton
            button.isSelected = (button.tag == selectedIndex)
        }
    }
    
    //MARK: - Func
    
    func selectSegment(index: Int) {
        guard index >= 0 && index < stackView.arrangedSubviews.count else { return }
        selectedIndex = index
        updateSegmentState(selectedIndex: index)
        guard isLayoutDone else { return }
        updateUnderbarPosition(to: index)
    }
    
    func changeSegmentTitle(at index: Int, to newTitle: String) {
        guard let button = stackView.arrangedSubviews[index] as? OFRSegmentedControlButton else { return }
        button.setTitle(newTitle, for: .normal)
    }
    
}
