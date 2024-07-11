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
        addSubviews(qrShapeBoxImageView, qrInstructionLabel)
    }
    
    private func setupLayout() {
        
    }
    
    private func setupStyle() {
        qrInstructionLabel.do { label in
            
        }
    }
    
    //MARK: - func
    
    
    
    
}
