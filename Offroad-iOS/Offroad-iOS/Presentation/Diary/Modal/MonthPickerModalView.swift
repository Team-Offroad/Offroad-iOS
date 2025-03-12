//
//  MonthPickerModelView.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 3/11/25.
//

import UIKit

import SnapKit
import Then

final class MonthPickerModalView: UIView {
    
    //MARK: - UI Properties
    
    let monthPickerView = UIPickerView()
    private let highlightedRowView = UIView()
    let completeButton = ShrinkableButton()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupHierarchy()
        setupStyle()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension MonthPickerModalView {
    
    // MARK: - Layout
    
    func setupStyle() {
        backgroundColor = .primary(.white)
        roundCorners(cornerRadius: 20, maskedCorners: [.layerMinXMaxYCorner, .layerMaxXMaxYCorner])
        
        highlightedRowView.do {
            $0.backgroundColor = .primary(.listBg)
            $0.roundCorners(cornerRadius: 8)
        }
        
        completeButton.do {
            $0.setTitle("완료", for: .normal)
            $0.titleLabel?.font = UIFont.offroad(style: .iosTooltipTitle)
            $0.setTitleColor(UIColor.sub(.sub), for: .normal)
        }
    }
    
    func setupHierarchy() {
        addSubviews(
            highlightedRowView,
            monthPickerView,
            completeButton
        )
    }
    
    func setupLayout() {
        highlightedRowView.snp.makeConstraints {
            $0.center.equalTo(monthPickerView.snp.center)
            $0.horizontalEdges.equalToSuperview().inset(10)
            $0.height.equalTo(34)
        }
        
        monthPickerView.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview()
            $0.verticalEdges.equalToSuperview().inset(60)
        }
         
        completeButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(26)
            $0.trailing.equalToSuperview().inset(34)
        }
    }
}
