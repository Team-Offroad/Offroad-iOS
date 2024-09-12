//
//  OFRPopupBaseView.swift
//  Offroad-iOS
//
//  Created by 김민성 on 9/12/24.
//

import UIKit

import SnapKit

class OFRPopupBackgroundView: UIView {
    
    //MARK: - Properties
    
    //MARK: - UI Properties
    
    let popupView = OFRPopupView()
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension OFRPopupBackgroundView {
    
    //MARK: - Layout
    
    private func setupLayout() {
        popupView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview().inset(24)
        }
    }
    
    //MARK: - @objc Func
    
    //MARK: - Private Func
    
    private func setupStyle() {
        // 배경색의 초깃값 - 투명하게
        // 애니메이션 효과로 UIColor.blackOpacity(.black55) 색으로 변경
        backgroundColor = .clear
    }
    
    private func setupHierarchy() {
        addSubview(popupView)
    }
    
    //MARK: - Func
    
}
