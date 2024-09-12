//
//  OFRPopupButton.swift
//  Offroad-iOS
//
//  Created by 김민성 on 9/12/24.
//

import UIKit



class OFRPopupButton: UIButton {
    
    //MARK: - Properties
    
    //MARK: - UI Properties
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

extension OFRPopupButton {
    
    //MARK: - Layout
    
    private func setupLayout() {
        self.snp.makeConstraints { make in
            make.height.equalTo(44)
        }
    }
    
    //MARK: - @objc Func
    
    //MARK: - Private Func
    
    private func setupStyle() {
        
    }
    
    private func setupHierarchy() {
        
    }
    
    //MARK: - Func
    
}
