//
//  QuestResultView.swift
//  Offroad-iOS
//
//  Created by 김민성 on 2024/07/18.
//

import UIKit

class QuestResultView: UIView {
    
    //MARK: - UI Properties
    
    let popupView = UIView()
    
    private let titleLabel = UILabel()
    private let subTitleLabel = UILabel()
    
    private let characterImageView = UIImageView(image: nil)
    
    let goToHomeButton = UIButton()
    
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
    
}

extension QuestResultView {
    
    //MARK: - Layout
    
    private func setupHierarchy() {
        
        popupView.addSubviews(
            titleLabel,
            subTitleLabel,
            characterImageView,
            goToHomeButton
        )
        addSubview(popupView)
    }
    
    private func setupLayout() {
        popupView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(24)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(38)
            make.horizontalEdges.equalToSuperview().inset(43)
        }
        
        subTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(12)
            make.centerX.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(20)
        }
        
        characterImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(subTitleLabel.snp.bottom).offset(12.74)
            make.width.equalTo(260)
            make.height.equalTo(162)
            make.horizontalEdges.equalToSuperview().inset(46)
        }
        
        goToHomeButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(characterImageView.snp.bottom)
            make.horizontalEdges.equalToSuperview().inset(45.5)
            make.bottom.equalToSuperview().inset(31)
            make.height.equalTo(48)
        }
    }
    
    
    //MARK: - Private Func
    
    private func setupStyle() {
        backgroundColor = .clear
        
        popupView.do { view in
            view.roundCorners(cornerRadius: 15)
            view.backgroundColor = .main(.main3)
        }
        
        titleLabel.do { label in
            label.text = "탐험 성공"
            label.font = .offroad(style: .iosTextTitle)
            label.textColor = .main(.main2)
            label.textAlignment = .center
        }
        
        characterImageView.do { view in
            view.contentMode = .scaleAspectFit
        }
        
        subTitleLabel.do { label in
            label.text = "탐험에 성공했어요!\n이곳에 무엇이 있는지 천천히 살펴볼까요?"
            label.font = .offroad(style: .iosTextRegular)
            label.numberOfLines = 2
            label.textColor = .main(.main2)
            label.textAlignment = .center
        }
        
        goToHomeButton.do { button in
            button.setTitle("홈으로", for: .normal)
            button.setBackgroundColor(.main(.main2), for: .normal)
            button.titleLabel?.textColor = .primary(.white)
            button.roundCorners(cornerRadius: 5)
        }
    }
    
    
    
    //MARK: - Func
    
    func configureView(result: QuestResult, imageURL: String?) {
        switch result {
        case .success:
            titleLabel.text = "탐험 성공"
            subTitleLabel.text = "탐험에 성공했어요!\n이곳에 무엇이 있는지 천천히 살펴볼까요?"
            goToHomeButton.setTitle("홈으로", for: .normal)
        case .wrongLocation:
            titleLabel.text = "탐험 실패"
            subTitleLabel.text = "탐험에 실패했어요.\n위치를 다시 한 번 확인해 주세요."
            subTitleLabel.highlightText(targetText: "위치", font: .offroad(style: .iosTextBold))
            goToHomeButton.setTitle("확인", for: .normal)
        case .wrongQR:
            titleLabel.text = "탐험 실패"
            subTitleLabel.text = "탐험에 실패했어요.\nQR코드를 다시 한 번 확인해 주세요."
            subTitleLabel.highlightText(targetText: "QR코드", font: .offroad(style: .iosTextBold))
            goToHomeButton.setTitle("확인", for: .normal)
        }
        guard let imageURL else { return }
        characterImageView.fetchSvgURLToImageView(svgUrlString: imageURL)
    }
    
    func configurePopupView(with placeInfo: RegisteredPlaceInfo) {
//        self.nameLabel.text = placeInfo.name
//        self.shortDescriptionLabel.text = placeInfo.shortIntroduction
//        self.addresssLabel.text = placeInfo.address
//        self.visitCountLabel.text = "탐험횟수:\(placeInfo.visitCount)"
    }
    
}

