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
    
    override var isSelected: Bool {
        didSet {
            feedbackGenerator.impactOccurred()
            guard var settingModel else { return }
            settingModel.isEnabled = isSelected
            settingSwitch.setOn(isSelected, animated: true)
        }
    }
    
    var settingModel: (any DeveloperSettingModelToggleable)?
    
    private let feedbackGenerator = UIImpactFeedbackGenerator()
    private var disposeBag = DisposeBag()
    
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
        
        settingSwitch.setOn(settingModel?.isEnabled ?? false, animated: true)
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
    
}
