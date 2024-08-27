//
//  TermsConsentView.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 8/23/24.
//

import UIKit

import SnapKit
import Then

final class TermsConsentView: UIView {

    //MARK: - UI Properties
    
    private let popupView = TermsConsentPopupView()
        
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

extension TermsConsentView {
    
    // MARK: - Layout
    
    private func setupStyle() {
        backgroundColor = .main(.main1)
    }
    
    private func setupHierarchy() {
        addSubviews(popupView)
    }
    
    private func setupLayout() {
        popupView.snp.makeConstraints {
            $0.edges.equalToSuperview()
        }
    }
}
