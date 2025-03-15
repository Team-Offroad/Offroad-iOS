//
//  DiaryView.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 3/4/25.
//

import UIKit

import FSCalendar
import SnapKit
import Then

final class DiaryView: UIView {
    
    //MARK: - UI Properties
    
    let customBackButton = NavigationPopButton()
    private let headerView = UIView()
    private let dividerView = UIView()
    private let titleLabel = UILabel()
    private let titleImageView = UIImageView(frame: CGRect(origin: .init(), size: CGSize(width: 24, height: 24)))
    let guideButton = UIButton()
    private let diaryBackgroundView = UIView()
    let monthButton = ShrinkableButton()
    let leftArrowButton = UIButton()
    let rightArrowButton = UIButton()
    private let arrowButtonStackView = UIStackView()
    private let roundedRectangleView = UIView()
    let diaryCalender = FSCalendar()
    
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

extension DiaryView {
    
    // MARK: - Layout
    
    private func setupStyle() {
        backgroundColor = .primary(.listBg)
        
        headerView.do {
            $0.backgroundColor = .main(.main1)
        }
        
        dividerView.do {
            $0.backgroundColor = .grayscale(.gray100)
        }
        
        titleImageView.do {
            $0.image = .imgSparkle
        }
        
        titleLabel.do {
            $0.text = "기억빛"
            $0.font = .offroad(style: .iosTextTitle)
            $0.textColor = .main(.main2)
            $0.textAlignment = .center
        }
        
        guideButton.do {
            $0.setImage(.iconGuide, for: .normal)
        }
        
        diaryBackgroundView.do {
            $0.backgroundColor = .main(.main1)
        }
        
        monthButton.do {
            let date = Date()
            let yearFormatter = DateFormatter()
            let monthFormatter = DateFormatter()
            yearFormatter.dateFormat = "yyyy"
            monthFormatter.dateFormat = "M"
            
            $0.setTitle("\(yearFormatter.string(from: date))년 \(monthFormatter.string(from: date))월", for: .normal)
            $0.setTitleColor(UIColor(hexCode: "595959"), for: .normal)
            $0.titleLabel?.font = .offroad(style: .iosTooltipTitle)
        }
        
        leftArrowButton.do {
            $0.setImage(.imgArrowLeftDiary, for: .normal)
        }
        
        rightArrowButton.do {
            $0.setImage(.imgArrowRightDiary, for: .normal)
            $0.alpha = 0
        }
        
        arrowButtonStackView.do {
            $0.axis = .horizontal
            $0.spacing = 145
            $0.alignment = .center
            $0.distribution = .equalSpacing
        }
        
        roundedRectangleView.do {
            $0.backgroundColor = .primary(.white)
            $0.roundCorners(cornerRadius: 20)
        }
        
        diaryCalender.do {
            $0.register(CustomDiaryCalendarCell.self, forCellReuseIdentifier: CustomDiaryCalendarCell.className)
            
            $0.backgroundColor = .clear
            $0.locale = Locale(identifier: "ko_KR")
            $0.scope = .month
            $0.placeholderType = .none
            $0.scrollEnabled = true

            $0.headerHeight = 0
            $0.weekdayHeight = 60

            $0.appearance.weekdayFont = .offroad(style: .iosBtnSmall)
            $0.appearance.weekdayTextColor = .grayscale(.gray400)
            $0.appearance.selectionColor = .clear
            $0.appearance.titleSelectionColor = .primary(.stroke)
            $0.appearance.titleFont = .pretendardFont(ofSize: 15, weight: .bold)
        }
    }
    
    private func setupHierarchy() {
        addSubviews(
            headerView,
            customBackButton,
            titleLabel,
            titleImageView,
            guideButton,
            dividerView,
            diaryBackgroundView
        )
        diaryBackgroundView.addSubviews(
            arrowButtonStackView,
            monthButton,
            roundedRectangleView)
        arrowButtonStackView.addArrangedSubviews(leftArrowButton, rightArrowButton)
        roundedRectangleView.addSubview(diaryCalender)
    }
    
    private func setupLayout() {
        headerView.snp.makeConstraints {
            $0.top.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(dividerView.snp.top)
        }
        
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
        
        guideButton.snp.makeConstraints {
            $0.centerY.equalTo(titleLabel.snp.centerY)
            $0.leading.equalTo(titleImageView.snp.trailing).offset(4)
        }
        
        dividerView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(1)
        }
        
        diaryBackgroundView.snp.makeConstraints {
            $0.top.equalTo(dividerView.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview()
            $0.height.equalTo(494)
        }
        
        monthButton.snp.makeConstraints {
            $0.center.equalTo(arrowButtonStackView)
        }
        
        arrowButtonStackView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(47)
            $0.centerX.equalToSuperview()
        }
        
        [leftArrowButton, rightArrowButton].forEach { button in
            button.snp.makeConstraints {
                $0.size.equalTo(24)
            }
        }
        
        roundedRectangleView.snp.makeConstraints {
            $0.top.equalToSuperview().inset(98)
            $0.bottom.equalToSuperview().inset(46)
            $0.horizontalEdges.equalToSuperview().inset(24)
        }
        
        diaryCalender.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.top.equalToSuperview().inset(7)
            $0.bottom.equalToSuperview().inset(30)
        }
    }
}
