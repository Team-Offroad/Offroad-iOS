//
//  QuestQRView.swift
//  Offroad-iOS
//
//  Created by 김민성 on 2024/07/11.
//

import UIKit

import SnapKit
import Then

class QuestQRView: UIView {
    
    //MARK: - Properties
    
    var qrTargetAreaSideLength: CGFloat!
    
    
    //MARK: - UI Properties
    
    let qrTargetAreaBox = UIView()
    let qrShapeBoxImageView = UIImageView(image: .icnSquareDashedCornerLeft)
    let qrInstructionLabel = UILabel()
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupHierarchy()
        setupLayout()
        setupStyle()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}




extension QuestQRView {
    
    //MARK: - @objc func
    
    
    //MARK: - private func
    
    private func setupHierarchy() {
        addSubviews(qrTargetAreaBox, qrShapeBoxImageView, qrInstructionLabel)
    }
    
    private func setupLayout() {
        
        
        let screenWidth = UIScreen.main.bounds.width
        let inset: CGFloat = 24
        qrTargetAreaSideLength = screenWidth - inset * 2
        qrTargetAreaBox.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(19)
            make.width.height.equalTo(qrTargetAreaSideLength)
            make.centerX.equalToSuperview()
        }
        
        qrShapeBoxImageView.snp.makeConstraints { make in
            make.top.equalTo(qrTargetAreaBox.snp.bottom).offset(42)
            make.centerX.equalToSuperview()
            make.width.height.equalTo(30)
        }
        
        qrInstructionLabel.snp.makeConstraints { make in
            make.top.equalTo(qrShapeBoxImageView.snp.bottom).offset(24)
            make.centerX.equalToSuperview()
        }
    }
    
    private func setupStyle() {
        backgroundColor = .grayscale(.gray200)
        qrTargetAreaBox.do { view in
            view.clipsToBounds = true
            view.layer.cornerRadius = 24
            view.layer.borderWidth = 3
            view.layer.borderColor = UIColor.sub(.sub).cgColor
        }
        qrInstructionLabel.do { label in
            label.text = """
            QR 코드가 잘 보이도록
            카메라를 비춰주세요
            """
            label.numberOfLines = 2
            label.textColor = .primary(.white)
            label.highlightText(targetText: "QR 코드", font: .offroad(style: .iosTextBold), color: .primary(.white))
        }
    }
    
    //MARK: - func
    
    
    
    
}
