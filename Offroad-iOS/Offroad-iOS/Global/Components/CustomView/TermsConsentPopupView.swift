//
//  TermsConsentPopupView.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 8/23/24.
//

import UIKit

import SnapKit
import Then

final class TermsConsentPopupView: UIView {
    
    //MARK: - Properties
    
    private let deviceWidth = UIScreen.main.bounds.width
    
    //MARK: - UI Properties
    
    private let popupView = UIView()
    private let titleLabel = UILabel()
    private let descriptionLabel = UILabel()
    private let contentLabel = UILabel()
    private let contentView = UIView()
    private let contentScrollView = UIScrollView()
    private let contentStackView = UIStackView()
    let disagreeButton = UIButton()
    let agreeButton = UIButton()
    private let buttonStackView = UIStackView()
    
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

extension TermsConsentPopupView {
    
    // MARK: - Layout
    
    private func setupStyle() {
        backgroundColor = .blackOpacity(.black25)
        
        popupView.do {
            $0.backgroundColor = .main(.main3)
            $0.roundCorners(cornerRadius: 15)
            $0.alpha = 0
        }
        
        titleLabel.do {
            $0.font = .offroad(style: .iosTextTitle)
            $0.textColor = .main(.main2)
            $0.textAlignment = .left
        }
        
        descriptionLabel.do {
            $0.font = .offroad(style: .iosMarketing)
            $0.textColor = .main(.main2)
            $0.textAlignment = .left
            $0.numberOfLines = 0
            $0.lineBreakMode = .byCharWrapping
        }
        
        contentLabel.do {
            $0.font = .offroad(style: .iosMarketing)
            $0.textColor = .grayscale(.gray400)
            $0.textAlignment = .left
            $0.numberOfLines = 0
            $0.lineBreakMode = .byCharWrapping
        }
        
        contentScrollView.do {
            $0.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 10)
        }
        
        contentStackView.do {
            $0.axis = .vertical
            $0.spacing = 24
            $0.alignment = .leading
        }
        
        disagreeButton.do {
            $0.setTitle("비동의", for: .normal)
            $0.setTitleColor(.main(.main2), for: .normal)
            $0.titleLabel?.font = .offroad(style: .iosBtnSmall)
            $0.backgroundColor = .clear
            $0.roundCorners(cornerRadius: 5)
            $0.layer.borderColor = UIColor.main(.main2).cgColor
            $0.layer.borderWidth = 1
        }
        
        agreeButton.do {
            $0.setTitle("동의", for: .normal)
            $0.setTitleColor(.primary(.white), for: .normal)
            $0.titleLabel?.font = .offroad(style: .iosBtnSmall)
            $0.backgroundColor = .main(.main2)
            $0.roundCorners(cornerRadius: 5)
        }
        
        buttonStackView.do {
            $0.axis = .horizontal
            $0.spacing = 14
            $0.distribution = .fillEqually
        }
    }
    
    private func setupHierarchy() {
        addSubview(popupView)
        popupView.addSubviews(titleLabel,contentScrollView, buttonStackView)
        contentScrollView.addSubview(contentView)
        contentView.addSubview(contentStackView)
        contentStackView.addArrangedSubviews(descriptionLabel, contentLabel)
        buttonStackView.addArrangedSubviews(disagreeButton, agreeButton)
    }
    
    private func setupLayout() {
        popupView.snp.makeConstraints {
            $0.height.equalTo(527)
            $0.width.equalToSuperview().inset(24)
            $0.center.equalToSuperview()
        }
        
        titleLabel.snp.makeConstraints {
            $0.top.equalToSuperview().inset(38)
            $0.horizontalEdges.equalToSuperview().inset(46)
        }
        
        contentScrollView.snp.makeConstraints {
            $0.top.equalTo(titleLabel.snp.bottom).offset(18)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalToSuperview().inset(125)
        }
        
        contentView.snp.makeConstraints {
            $0.edges.equalToSuperview()
            $0.width.equalToSuperview()
        }
        
        contentStackView.snp.makeConstraints {
            $0.verticalEdges.equalToSuperview()
            $0.horizontalEdges.equalToSuperview().inset(46)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.bottom.equalToSuperview().inset(38)
            $0.horizontalEdges.equalToSuperview().inset(46)
            $0.height.equalTo(48)
        }
    }
    
    //MARK: - Private Func
    
    private func applyConditionalIndent(targetString: String) -> (NSMutableAttributedString) {
        let resultString = NSMutableAttributedString()
        let strings = targetString.components(separatedBy: "\n")
        let specialNumberStrings: Set<String> = ["1. ", "2. ", "3. ", "4. ", "5. ", "6. ", "7. ", "8. ", "9. ", " ∙ "]
        let specialHangeulStrings: Set<String> = ["가. ", "나. ", "다. ", "라. ", "마. ", "바. ", "사. ", "아. "]
        var textIndent: CGFloat
        
        for string in strings {
            let numberedItem = "\(string)\n"
            let attributedItem = NSMutableAttributedString(string: numberedItem)
            let prefix = String(string.prefix(3))
            let isContainSpecialNumberString = specialNumberStrings.contains(prefix)
            let isContainSpecialHangeulString = specialHangeulStrings.contains(prefix)
            let style = NSMutableParagraphStyle()
            
            if isContainSpecialNumberString || isContainSpecialHangeulString {
                textIndent = {
                    let label = UILabel()
                    label.text = prefix
                    label.font = .offroad(style: .iosMarketing)
                    
                    return label.sizeThatFits(.zero).width
                }()
                
                if isContainSpecialNumberString {
                    style.firstLineHeadIndent = 10
                    style.headIndent = textIndent + 10
                } else if isContainSpecialHangeulString {
                    style.firstLineHeadIndent = 30
                    style.headIndent = textIndent + 30
                }
            }
            style.lineSpacing = 6
            attributedItem.addAttribute(.paragraphStyle, value: style, range: NSRange(location: 0, length: attributedItem.length))

            resultString.append(attributedItem)
        }
        
        return resultString
    }
    
    //MARK: - Func
    
    func configurePopupView(titleString: String, descriptionString: String, contentString: String) {
        titleLabel.text = titleString
        contentLabel.attributedText = applyConditionalIndent(targetString: contentString)
        
        if descriptionString == "" {
            descriptionLabel.isHidden = true
        } else {
            descriptionLabel.text = descriptionString
            descriptionLabel.setLineSpacing(spacing: 6)
        }
    }
    
    func presentPopupView() {
        popupView.executePresentPopupAnimation()
    }
    
    func dismissPopupView() {
        backgroundColor = .clear
        popupView.executeDismissPopupAnimation()
    }
}
