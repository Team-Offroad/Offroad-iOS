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
    
    //MARK: - UI Properties
    
    let naverMapView = NMFNaverMapView()
    let reloadLocationButton = UIButton()
    
    let questListButton = QuestMapListButton(image: .iconListBullet, title: "퀘스트 목록")
    let placeListButton = QuestMapListButton(image: .iconPlaceMarker, title: "장소 목록")
    let listButtonStackView = UIStackView()
    
    let compass = NMFCompassView()
    
    //MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupHierarchy()
        setupStyle()
        setupLayout()
        setupInitialNaverMapView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


extension QuestMapView {
    
    //MARK: - Layout
    
    private func setupHierarchy() {
        naverMapView.addSubview(reloadLocationButton)
        listButtonStackView.addArrangedSubviews(questListButton, placeListButton)
        addSubviews(
            naverMapView,
            listButtonStackView,
            compass
        )
    }
    
    private func setupStyle() {
        reloadLocationButton.do { button in
            button.setImage(.btnArrowClockwise, for: .normal)
        }
        
        listButtonStackView.do { stackView in
            stackView.axis = .horizontal
            stackView.spacing = 14
            stackView.alignment = .fill
            stackView.distribution = .fillEqually
        }
    }
    
    private func setupLayout() {
        naverMapView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.verticalEdges.equalTo(safeAreaLayoutGuide.snp.verticalEdges)
        }
        
        reloadLocationButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(24)
            make.trailing.equalTo(safeAreaLayoutGuide.snp.trailing).inset(24)
            make.width.height.equalTo(44)
        }
        
        listButtonStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.horizontalEdges.equalTo(safeAreaLayoutGuide.snp.horizontalEdges).inset(40)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom).inset(40)
        }
        
        compass.snp.makeConstraints { make in
            make.top.equalTo(reloadLocationButton.snp.bottom).offset(24)
            make.trailing.equalTo(reloadLocationButton.snp.trailing)
            make.width.height.equalTo(44)
        }
    }
    
    private func setupInitialNaverMapView() {
        naverMapView.showZoomControls = false
        naverMapView.mapView.logoAlign = .leftTop
        naverMapView.showCompass = false
        
        compass.contentMode = .scaleAspectFit
        compass.mapView = naverMapView.mapView
    }
    
}
