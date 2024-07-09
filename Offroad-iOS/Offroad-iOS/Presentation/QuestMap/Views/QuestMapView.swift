//
//  QuestMapView.swift
//  Offroad-iOS
//
//  Created by 김민성 on 2024/07/07.
//

import UIKit

import NMapsMap
import SnapKit
import Then

class QuestMapView: UIView {
    
    let naverMapView = NMFNaverMapView()
    let reloadLocationButton = UIButton()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupHierarchy()
        setupLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension QuestMapView {
    
    private func setupHierarchy() {
        addSubviews(naverMapView)
    }
    
    private func setupStyle() {
        
    }
    
    private func setupLayout() {
        naverMapView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide.snp.edges)
        }
    }
    
}
