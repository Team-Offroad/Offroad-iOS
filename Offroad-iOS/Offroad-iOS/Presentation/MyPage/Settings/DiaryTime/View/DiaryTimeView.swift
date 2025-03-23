//
//  DiaryTimeView.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 2/17/25.
//

import UIKit

import SnapKit
import Then

final class DiaryTimeView: UIView {
    
    //MARK: - UI Properties
    
    let customBackButton = NavigationPopButton()
    private let dividerView = UIView()
    private let titleLabel = UILabel()
    private let titleImageView = UIImageView(frame: CGRect(origin: .init(), size: CGSize(width: 24, height: 24)))
    private let diaryTimeImageView = UIImageView()
    private let questionLabel = UILabel()
    let timePickerView = UIPickerView()
    private let highlightedRowView = UIView()
    private let colonLabel = UILabel()
    private let descriptionStackView = UIStackView()
    private let checkCircleImageView = UIImageView(image: UIImage(resource: .iconCheckCircle))
    private let descriptionLabel1 = UILabel()
    private let descriptionLabel2 = UILabel()
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

extension DiaryTimeView {
    
    // MARK: - Layout
    
    private func setupStyle() {
        backgroundColor = .main(.main1)
        
        customBackButton.do {
            $0.configureButtonTitle(titleString: "설정")
        }
        
        dividerView.do {
            $0.backgroundColor = .grayscale(.gray100)
        }
        
        titleImageView.do {
            $0.image = .imgClock
        }
        
        titleLabel.do {
            $0.text = "일기 시간"
            $0.font = .offroad(style: .iosTextTitle)
            $0.textColor = .main(.main2)
            $0.textAlignment = .center
            $0.setContentCompressionResistancePriority(.defaultHigh + 1, for: .vertical)
        }
        
        diaryTimeImageView.do {
            $0.image = .imgDiaryTimeCharacter
            $0.contentMode = .scaleAspectFit
        }
        
        questionLabel.do {
            $0.text = "매일 몇 시에 일기를 받아볼까요?"
            $0.font = .offroad(style: .iosText)
            $0.textColor = .main(.main2)
            $0.textAlignment = .center
            $0.setLineHeight(percentage: 150)
            $0.setContentCompressionResistancePriority(.defaultHigh + 1, for: .vertical)
        }
        
        highlightedRowView.do {
            $0.backgroundColor = .primary(.listBg)
            $0.roundCorners(cornerRadius: 8)
        }
        
        colonLabel.do {
            $0.text = ":"
            $0.font = .offroad(style: .iosTextTitle)
            $0.textColor = .main(.main2)
        }
        
        descriptionStackView.do {
            $0.axis = .horizontal
            $0.spacing = 6
            $0.alignment = .center
        }
        
        descriptionLabel1.do {
            $0.text = "시간을 설정하면,"
            $0.font = .offroad(style: .iosBoxMedi)
            $0.textColor = .sub(.sub2)
            $0.textAlignment = .center
            $0.setLineHeight(percentage: 160)
            $0.setContentCompressionResistancePriority(.defaultHigh + 1, for: .vertical)
        }
        
        descriptionLabel2.do {
            $0.text = "최소 12시간 후에 일기를 받을 수 있어요."
            $0.font = .offroad(style: .iosBoxMedi)
            $0.textColor = .sub(.sub2)
            $0.textAlignment = .center
            $0.setLineHeight(percentage: 160)
            $0.setContentCompressionResistancePriority(.defaultHigh + 1, for: .vertical)
        }
        
        completeButton.do {
            $0.setTitle("완료", for: .normal)
            $0.setBackgroundColor(.main(.main2), for: .normal)
            $0.titleLabel?.font = UIFont.offroad(style: .iosText)
            $0.setTitleColor(UIColor.main(.main1), for: .normal)
            $0.roundCorners(cornerRadius: 5)
        }
    }
    
    private func setupHierarchy() {
        addSubviews(
            customBackButton,
            titleLabel,
            titleImageView,
            dividerView,
            diaryTimeImageView,
            questionLabel,
            highlightedRowView,
            colonLabel,
            timePickerView,
            descriptionStackView,
            descriptionLabel2,
            completeButton
        )
        
        descriptionStackView.addArrangedSubviews(checkCircleImageView, descriptionLabel1)
    }
    
    private func setupLayout() {
        customBackButton.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(12)
            $0.leading.equalToSuperview().inset(12)
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(98)
            $0.leading.equalToSuperview().inset(24)
        }
        
        titleImageView.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.leading.equalTo(titleLabel.snp.trailing).offset(8)
        }
        
        dividerView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        diaryTimeImageView.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(safeAreaLayoutGuide).inset(160)
            $0.top.lessThanOrEqualTo(safeAreaLayoutGuide).inset(176)
            $0.centerX.equalToSuperview()
            $0.width.greaterThanOrEqualToSuperview().inset(140)
            $0.width.lessThanOrEqualToSuperview().inset(81)
            $0.height.equalTo(diaryTimeImageView.snp.width)
        }
        
        questionLabel.snp.makeConstraints {
            $0.top.equalTo(diaryTimeImageView.snp.bottom).offset(4)
            $0.centerX.equalToSuperview()
        }
        
        highlightedRowView.snp.makeConstraints {
            $0.center.equalTo(timePickerView.snp.center)
            $0.horizontalEdges.equalToSuperview().inset(10)
            $0.height.equalTo(34)
        }
        
        colonLabel.snp.makeConstraints {
            $0.centerX.equalTo(timePickerView.snp.centerX).offset(-31)
            $0.centerY.equalTo(timePickerView.snp.centerY).offset(-2)
        }
        
        timePickerView.snp.makeConstraints {
            $0.top.equalTo(questionLabel.snp.bottom).offset(10)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(110)
        }
        
        descriptionStackView.snp.makeConstraints {
            $0.top.greaterThanOrEqualTo(timePickerView.snp.bottom).offset(10)
            $0.top.lessThanOrEqualTo(timePickerView.snp.bottom).offset(35)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(22)
        }
        
        descriptionLabel2.snp.makeConstraints {
            $0.top.equalTo(descriptionStackView.snp.bottom)
            $0.centerX.equalToSuperview()
            $0.height.equalTo(22)
            $0.bottom.greaterThanOrEqualTo(completeButton.snp.top).offset(-36)
            $0.bottom.lessThanOrEqualTo(completeButton.snp.top).offset(-10)
        }
         
        completeButton.snp.makeConstraints {
            $0.bottom.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(24)
            $0.height.equalTo(54)
        }
    }
}
