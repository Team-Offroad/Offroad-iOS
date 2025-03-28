//
//  NoticePostView.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 8/16/24.
//

import UIKit

import SnapKit
import Then

final class NoticePostView: UIView {

    //MARK: - Properties
    
    private let deviceWidth = UIScreen.main.bounds.width
    
    //MARK: - UI Properties

    let customBackButton = NavigationPopButton()
    private let dateLabel = UILabel()
    private let titleLabel = UILabel()
    private let labelStackView = UIStackView()
    private let dividerView = UIView()
    private let contentScrollView = UIScrollView()
    private let contentView = UIView()
    private let contentLabel = UILabel()
    lazy var contentButton = UIButton()
    private let contentStackView = UIStackView()
        
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

extension NoticePostView {
    
    // MARK: - Layout
    
    private func setupStyle() {
        backgroundColor = .main(.main1)
        
        customBackButton.do {
            $0.configureButtonTitle(titleString: "목록")
        }
        
        dateLabel.do {
            $0.font = .offroad(style: .iosTextContentsSmall)
            $0.textColor = .grayscale(.gray400)
            $0.textAlignment = .center
        }
        
        titleLabel.do {
            $0.font = .offroad(style: .iosSubtitle2Semibold)
            $0.textColor = .main(.main2)
            $0.textAlignment = .center
        }
        
        labelStackView.do {
            $0.axis = .vertical
            $0.spacing = 10
            $0.alignment = .leading
        }
        
        dividerView.do {
            $0.backgroundColor = .primary(.listBg)
        }
        
        contentLabel.do {
            $0.font = .offroad(style: .iosText)
            $0.textColor = .main(.main2)
            $0.textAlignment = .left
            $0.numberOfLines = 0
            $0.preferredMaxLayoutWidth = deviceWidth - 48
            $0.lineBreakMode = .byWordWrapping
        }
        
        contentButton.do {
            $0.isHidden = true
            $0.setTitleColor(.sub(.sub2), for: .normal)
            $0.titleLabel?.font = .offroad(style: .iosText)
        }
        
        contentStackView.do {
            $0.axis = .vertical
            $0.spacing = 24
            $0.alignment = .leading
        }
    }
    
    private func setupHierarchy() {
        addSubviews(
            customBackButton,
            labelStackView,
            dividerView,
            contentScrollView
        )
        
        labelStackView.addArrangedSubviews(dateLabel, titleLabel)
        contentScrollView.addSubview(contentView)
        contentView.addSubview(contentStackView)
        contentStackView.addArrangedSubviews(contentLabel, contentButton)
    }
    
    private func setupLayout() {
        customBackButton.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(12)
            $0.leading.equalToSuperview().inset(12)
        }
        
        labelStackView.snp.makeConstraints {
            $0.top.equalTo(safeAreaLayoutGuide).inset(79)
            $0.leading.equalToSuperview().inset(24)
        }
        
        dividerView.snp.makeConstraints {
            $0.top.equalTo(labelStackView.snp.bottom).offset(24)
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.height.equalTo(2)
        }
        
        contentScrollView.snp.makeConstraints {
            $0.top.equalTo(dividerView.snp.bottom)
            $0.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        contentStackView.snp.makeConstraints {
            $0.edges.equalToSuperview().inset(24)
        }
    }
    
    //MARK: - Func
    
    func setPostText(data: NoticeInfo) {
        let importantText = "[중요]"
        
        titleLabel.text = data.isImportant ? "\(importantText) \(data.title)" : data.title
        titleLabel.highlightText(targetText: importantText, color: .sub(.sub2))
                
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
        
        if let date = dateFormatter.date(from: data.updateAt) {
            dateFormatter.dateFormat = "yyyy / MM / dd"
            dateLabel.text = dateFormatter.string(from: date)
        }
        
        contentLabel.text = data.content
        
        if data.hasExternalLinks {
            contentButton.isHidden = false
            contentButton.setTitle("\(data.externalLinksTitles.first ?? "")", for: .normal)
        }
    }
}
