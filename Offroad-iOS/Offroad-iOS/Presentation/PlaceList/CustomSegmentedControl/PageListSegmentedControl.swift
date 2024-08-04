//
//  PageListSegmentedControl.swift
//  Offroad-iOS
//
//  Created by 김민성 on 8/3/24.
//

import UIKit

import SnapKit

protocol PlaceListSegmentedControlDelegate: AnyObject {
    func segmentedControlDidSelected(segmentedControl: PlaceListSegmentedControl, selectedIndex: Int)
}

final class PlaceListSegmentedControl: UIStackView, CustomSegmentedControlType {
    
    typealias ConcreteType = PlaceListSegmentedControl
    
    //MARK: - Properties
    
    private(set) var currentIndex: Int = 0
    weak var delegate: PlaceListSegmentedControlDelegate? = nil
    
    lazy var underbarLeadingConstraint = underbar.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0)
    lazy var underbarTrailingConstraint = underbar.trailingAnchor.constraint(equalTo: self.leadingAnchor, constant: 0)
    
    //MARK: - UI Properties
    
    let underbar: UIView = {
        let view = UIView()
        view.backgroundColor = .sub(.sub)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStackViewLayout()
        setupHierarchy()
        setupLayout()
        setButtonsTarget()
    }
    
    convenience init(titles: [String]) {
        var buttonsArray: [PlaceListSegmentButton] = []
        for i in 0..<titles.count {
            let button = PlaceListSegmentButton(title: titles[i], tag: i)
            buttonsArray.append(button)
        }
        
        self.init(arrangedSubviews: buttonsArray)
        
        setupStackViewLayout()
        setupHierarchy()
        setupLayout()
        setButtonsTarget()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension PlaceListSegmentedControl {
    
    //MARK: - Private Func
    
    private func setupHierarchy() {
        addSubviews(underbar)
    }
    
    private func setupLayout() {
        underbarLeadingConstraint.isActive = true
        underbarTrailingConstraint.isActive = true
        
        underbar.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.height.equalTo(3)
        }
    }
    
    func addSegments(titles: [String]) {
        var buttonsArray: [PlaceListSegmentButton] = []
        for i in 0..<titles.count {
            let button = PlaceListSegmentButton(title: titles[i], tag: i)
            buttonsArray.append(button)
        }
        buttonsArray.forEach { segmentButton in
            addArrangedSubview(segmentButton)
        }
        
        setButtonsTarget()
    }
    
    private func setupStackViewLayout() {
        axis = .horizontal
        distribution = .fillEqually
        spacing = 0
    }
    
    private func setButtonsTarget() {
        self.arrangedSubviews.forEach { view in
            guard let button = view as? PlaceListSegmentButton else { return }
            button.addTarget(self, action: #selector(segmentDidTapped(sender:)), for: .touchUpInside)
        }
    }
    
    @objc private func segmentDidTapped(sender: UIButton) {
        selectSegment(index: sender.tag)
    }
    
    //MARK: - Func
    
    func selectSegment(index: Int) {
        updateSegmentState(selectedIndex: index)
        setUnderbarPosition(to: index)
        delegate?.segmentedControlDidSelected(segmentedControl: self, selectedIndex: index)
    }
    
    func changeSegmentTitle(at index: Int, to newTitle: String) {
        guard let button = arrangedSubviews[index] as? PlaceListSegmentButton else { return }
        button.setTitle(newTitle, for: .normal)
    }
    
}
