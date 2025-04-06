//
//  DeveloperModeSwitchCell.swift
//  ORB_Dev
//
//  Created by 김민성 on 4/5/25.
//

import UIKit

import RxSwift
import RxCocoa

final class DeveloperModeSwitchCell: ShrinkableCollectionViewCell {
    
    //MARK: - Properties
    
    override var isHighlighted: Bool {
        didSet {
            if isHighlighted {
                feedbackGenerator.prepare()
                contentView.backgroundColor = .primary(.listBg)
            } else {
                contentView.backgroundColor = .main(.main1)
            }
        }
    }
    
    private let feedbackGenerator = UIImpactFeedbackGenerator()
    private var settingModel: (any DeveloperSettingModelToggleable)?
    
    //MARK: - UI Properties
    
    private let titleLabel = UILabel()
    private let settingSwitch = UISwitch()
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupHierarchy()
        setupStyle()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        settingModel = nil
        settingSwitch.setOn(false, animated: false)
    }
    
}

private extension DeveloperModeSwitchCell {
    
    private func setupStyle() {
        backgroundColor = .main(.main1)
        roundCorners(cornerRadius: 12)
        
        titleLabel.do {
            $0.textColor = .main(.main2)
            $0.textAlignment = .center
            $0.font = .offroad(style: .iosTabbarMedi)
        }
        
        settingSwitch.do {
            $0.onTintColor = .sub(.sub)
            $0.isUserInteractionEnabled = false
        }
    }
    
    private func setupHierarchy() {
        contentView.addSubviews(titleLabel, settingSwitch)
    }
    
    // MARK: - Layout Func
    
    private func setupLayout() {
        titleLabel.snp.makeConstraints {
            $0.leading.centerY.equalToSuperview().inset(14)
        }
        
        settingSwitch.snp.makeConstraints {
            $0.centerY.equalToSuperview()
            $0.trailing.equalToSuperview().inset(14)
        }
    }
    
}

extension DeveloperModeSwitchCell {
    
    //MARK: - Public Func
    
    public func configure(with model: any DeveloperSettingModelToggleable) {
        settingModel = model
        titleLabel.text = model.title
    }
    
    /// 셀 안에 있는 스위치의 on/off 여부만을 변경. 관련된 다른 model 데이터 등을 바꾸지는 않는다.
    /// - Parameters:
    ///   - selected: 표현하고자 하는 switch의 on/off 값
    ///   - animated: 애니메이션 여부
    public func setSelectionAppearance(to selected: Bool, animated: Bool) {
        settingSwitch.setOn(selected, animated: animated)
    }
    
    /// on/off로 스위치 가능한 항목의 변경. 셀의 외관 및 데이터를 함께 변경함.
    /// - Parameters:
    ///   - animated: 애니메이션 여부
    ///   - withHapticFeedback: 햅틱 피드백 여부
    public func toggle(animated: Bool, withHapticFeedback: Bool) {
        guard var settingModel else { return }
        let currentState = settingModel.isEnabled
        if withHapticFeedback { feedbackGenerator.impactOccurred() }
        setSelectionAppearance(to: !currentState, animated: animated)
        settingModel.isEnabled = !currentState
    }
    
}
