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
    
    let questListButton = QuestMapListButton(image: .iconListBullet, title: "퀘스트 목록")
    let placeListButton = QuestMapListButton(image: .iconPlaceMarker, title: "장소 목록")
    
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


extension QuestMapView {
    
    private func setupHierarchy() {
        naverMapView.addSubview(reloadLocationButton)
        
        addSubviews(
            naverMapView,
            questListButton,
            placeListButton
        )
    }
    
    private func setupStyle() {
        reloadLocationButton.do { button in
            button.setImage(.btnArrowClockwise, for: .normal)
        }
    }
    
    private func setupLayout() {
        naverMapView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide.snp.edges)
        }
        
        reloadLocationButton.snp.makeConstraints { make in
            make.top.trailing.equalToSuperview().inset(24)
            make.width.height.equalTo(44)
        }
    }
    
}
