//
//  ORBRecommendationChatView.swift
//  ORB_Dev
//
//  Created by 김민성 on 5/4/25.
//

import UIKit

import RxSwift
import RxCocoa
import SnapKit
import Then

final class ORBRecommendationChatView: UIView {
    
    // MARK: - Properties
    
    private var disposeBag = DisposeBag()
    
    // MARK: - UI Properties
    
    private let background = ORBRecommendationChatBackgroundView()
    private(set) var xButton = UIButton()
    private(set) var collectionView: UICollectionView! = nil
    private(set) var chatInputView = ChatTextInputView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupGestures()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}


private extension ORBRecommendationChatView {
    
    func setupStyle() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.minimumLineSpacing = 16
        layout.minimumInteritemSpacing = 0
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.do { collectionView in
            collectionView.backgroundColor = .clear
            collectionView.contentInset = .init(top: safeAreaInsets.top + 63.5, left: 0, bottom: 20, right: 0)
        }
        
        chatInputView.roundCorners(cornerRadius: 20, maskedCorners: [.layerMinXMinYCorner, .layerMaxXMinYCorner])
        chatInputView.layer.cornerCurve = .continuous
        
        xButton.do { button in
            button.setImage(.iconClose, for: .normal)
        }
    }
    
    func setupHierarchy() {
        addSubviews(background, collectionView, chatInputView, xButton)
    }
    
    func setupLayout() {
        background.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        chatInputView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        xButton.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).inset(3.3)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(13.7)
            make.size.equalTo(44)
        }
        
        collectionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.horizontalEdges.equalTo(safeAreaLayoutGuide)
            make.bottom.equalTo(keyboardLayoutGuide.snp.top).offset(-60)
        }
    }
    
    func setupGestures() {
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event.asDriver().drive { _ in
            self.endEditing(true)
        }.disposed(by: disposeBag)
        collectionView.addGestureRecognizer(tapGesture)
    }
    
}
