//
//  TitlePopupView.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 7/11/24.
//

import UIKit

import SnapKit
import Then

final class TitlePopupView: UIView {
    
    //MARK: - Properties
    
    typealias ChangeTitleButtonAction = () -> Void
    typealias CloseButtonAction = () -> Void

    private var changeTitleButtonAction: ChangeTitleButtonAction?
    private var closeButtonAction: CloseButtonAction?

    //MARK: - UI Properties
    
    private let popupView = UIView()
    private let myTitleLabel = UILabel()
    private let closeButton = UIButton()
    private let titleCollectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewLayout())
    private var changeTitleButton = OffroadButton(state: .isDisabled, title: "바꾸기")
        
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

extension TitlePopupView {
    
    // MARK: - Layout
    
    private func setupStyle() {
        backgroundColor = .blackOpacity(.black55)
        
        popupView.do {
            $0.backgroundColor = .main(.main3)
            $0.roundCorners(cornerRadius: 15)
        }
        
        myTitleLabel.do {
            $0.text = "내가 모은 칭호"
            $0.textAlignment = .center
            $0.textColor = .main(.main2)
            $0.font = .offroad(style: .iosTextTitle)
        }
        
        closeButton.do {
            $0.setImage(UIImage(resource: .iconClose), for: .normal)
        }
        
        titleCollectionView.do {
            let flowLayout = UICollectionViewFlowLayout()
            flowLayout.scrollDirection = .vertical
            $0.collectionViewLayout = flowLayout
            $0.register(TitleCollectionViewCell.self, forCellWithReuseIdentifier: TitleCollectionViewCell.className)

            $0.backgroundColor = .clear
            $0.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 12)
        }
    }
    
    private func setupHierarchy() {
        addSubview(popupView)
        popupView.addSubviews(
            myTitleLabel,
            closeButton,
            titleCollectionView,
            changeTitleButton
        )
    }
    
    private func setupLayout() {
        popupView.snp.makeConstraints {
            $0.height.equalTo(430)
            $0.width.equalTo(345)
            $0.center.equalToSuperview()
        }
        
        myTitleLabel.snp.makeConstraints {
            $0.centerX.equalToSuperview()
            $0.top.equalToSuperview().inset(32)
        }
        
        closeButton.snp.makeConstraints {
            $0.top.equalToSuperview().inset(13)
            $0.trailing.equalToSuperview().inset(12)
            $0.height.width.equalTo(44)
        }
        
        titleCollectionView.snp.makeConstraints {
            $0.top.equalTo(myTitleLabel.snp.bottom).offset(32)
            $0.horizontalEdges.equalToSuperview()
            $0.bottom.equalTo(changeTitleButton.snp.top).offset(-12)
        }
        
        changeTitleButton.snp.makeConstraints {
            $0.horizontalEdges.equalToSuperview().inset(24)
            $0.bottom.equalToSuperview().inset(20)
            $0.height.equalTo(54)
        }
    }
    
    //MARK: - @Objc
    
    @objc private func changeTitleButtonTapped() {
        changeTitleButtonAction?()
    }
    
    @objc private func closeButtonTapped() {
        closeButtonAction?()
    }
    
    //MARK: - targetView Method
    
    func setupChangeTitleButton(action: @escaping ChangeTitleButtonAction) {
        changeTitleButton.changeState(forState: .isEnabled)
        
        changeTitleButtonAction = action
        changeTitleButton.addTarget(self, action: #selector(changeTitleButtonTapped), for: .touchUpInside)
    }
    
    func setupCloseButton(action: @escaping ChangeTitleButtonAction) {
        closeButtonAction = action
        closeButton.addTarget(self, action: #selector(closeButtonTapped), for: .touchUpInside)
    }
    
    func setupTitleCollectionView(_ viewController: UIViewController) {
        titleCollectionView.dataSource = viewController as? UICollectionViewDataSource
        titleCollectionView.delegate = viewController as? UICollectionViewDelegate
    }
    
    func getTitleCollectionViewWidth() -> CGFloat {
        return titleCollectionView.frame.size.width
    }
}
