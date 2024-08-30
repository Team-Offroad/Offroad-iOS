//
//  TermsListTableViewCell.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 8/28/24.
//

import UIKit

import SnapKit
import Then

final class TermsListTableViewCell: UITableViewCell {
    
    //MARK: - Properties
    
    typealias AgreeButtonAction = () -> Void
    
    private var agreeButtonAction: AgreeButtonAction?
    
    //MARK: - UI Properties
    
    let agreeButton = UIButton()
    private let selectionStatusImageView = UIImageView(image: UIImage(resource: .imgOptional))
    private let titleLabel = UILabel()
    private let cellStackView = UIStackView()
//    private let arrowImageView = UIImageView(image: UIImage(resource: .iconArrow))

    //MARK: - Life Cycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupHierarchy()
        setupStyle()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()

        contentView.frame = contentView.frame.inset(
            by: UIEdgeInsets(top: 7, left: .zero, bottom: 7, right: .zero)
        )
    }
}

extension TermsListTableViewCell {
    
    // MARK: - Layout
    
    private func setupStyle() {
        backgroundColor = .clear
        
        agreeButton.do {
            $0.adjustsImageWhenHighlighted = false
            $0.setImage(.btnUnchecked, for: .normal)
            $0.setImage(.btnChecked, for: .selected)
        }
        
        titleLabel.do {
            $0.textColor = .main(.main2)
            $0.textAlignment = .center
            $0.font = .offroad(style: .iosTextContents)
        }
        
        cellStackView.do {
            $0.axis = .horizontal
            $0.spacing = 8
            $0.alignment = .center
        }
    }
    
    private func setupHierarchy() {
        contentView.addSubviews(cellStackView)
        cellStackView.addArrangedSubviews(
            agreeButton,
            selectionStatusImageView,
            titleLabel
        )
    }
    
    private func setupLayout() {
        cellStackView.snp.makeConstraints {
            $0.leading.centerY.equalToSuperview()
        }
    }
    
    // MARK: - Func
    
    func configureCell(data: TermsModel) {
        titleLabel.text = data.titleString
        
        selectionStatusImageView.image = data.isRequired ? UIImage(resource: .imgRequired) : UIImage(resource: .imgOptional)
    
    }
    
    // MARK: - targetView Method

    func setupAgreeButton(action: @escaping AgreeButtonAction) {
        agreeButtonAction = action
        agreeButton.addTarget(self, action: #selector(agreeButtonTapped), for: .touchUpInside)
    }
    
    //MARK: - @Objc Func
    
    @objc private func agreeButtonTapped() {
        agreeButton.isSelected.toggle()
        agreeButtonAction?()
    }
}
