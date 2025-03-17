//
//  CustomDiaryCalendarCell.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 3/10/25.
//

import UIKit

import FSCalendar
import SnapKit

final class CustomDiaryCalendarCell: FSCalendarCell {
    
    //MARK: - Properties
    
    private lazy var circleDiameter = min(contentView.bounds.width, contentView.bounds.height) * 0.8
    
    //MARK: - UI Properties
    
    private let defaultBackgroundView = UIView()
    private lazy var gradientBlurBackgroundView = MemoryLightGradientView()
    
    //MARK: - Life Cycle

    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
    }

    required init?(coder aDecoder: NSCoder!) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        gradientBlurBackgroundView.subviews.forEach { $0.removeFromSuperview() }
        if gradientBlurBackgroundView.layer.sublayers != nil {
            gradientBlurBackgroundView.layer.sublayers?.forEach { $0.removeFromSuperlayer() }
        }

        gradientBlurBackgroundView.isHidden = true
        titleLabel.textColor = .primary(.stroke)
    }
}

private extension CustomDiaryCalendarCell {
    
    //MARK: - Layout
    
    func setupStyle() {
        backgroundColor = .clear
        
        defaultBackgroundView.do {
            $0.backgroundColor = .primary(.boxInfo)
            $0.roundCorners(cornerRadius: circleDiameter / 2)
        }
        
        gradientBlurBackgroundView.do {
            $0.roundCorners(cornerRadius: circleDiameter / 2)
            $0.isHidden = true
        }
    }
    
    func setupHierarchy() {
        contentView.insertSubview(defaultBackgroundView, at: 0)
        contentView.insertSubview(gradientBlurBackgroundView, at: 1)
    }
    
    func setupLayout() {
        titleLabel.snp.makeConstraints {
            $0.center.equalToSuperview()
        }
        
        [defaultBackgroundView, gradientBlurBackgroundView].forEach { view in
            view.snp.makeConstraints {
                $0.center.equalToSuperview()
                $0.size.equalTo(circleDiameter)
            }
        }
    }
}

extension CustomDiaryCalendarCell {
    
    //MARK: - Method
    
    func configureMemoryLightCell(pointColorCode: String, baseColorCode: String) {
        gradientBlurBackgroundView.setupGradientBlurView(pointColorCode: pointColorCode, baseColorCode: baseColorCode)
        gradientBlurBackgroundView.isHidden = false
        
        let blurEffectView = CustomIntensityBlurView(blurStyle: .light, intensity: 0.1)
        blurEffectView.frame = bounds
        
        gradientBlurBackgroundView.addSubview(blurEffectView)
    }
}
