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
    
    private let listButtonStackView = UIStackView()
    let questListButton = QuestMapListButton(image: .iconListBullet, title: "퀘스트 목록")
    let placeListButton = QuestMapListButton(image: .iconPlaceMarker, title: "장소 목록")
    
    let naverMapView = NMFNaverMapView()
    private let showLocationButton = NMFLocationButton(frame: .zero)
    private let compass = NMFCompassView()
    private let orangeTriangleArrowOverlayImage = NMFOverlayImage(image: .icnOrangeTriangleArrow)
    let orangeLocationOverlayImage = NMFOverlayImage(image: .icnOrangeCircleInWhiteBorder)
    
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
    
    private func setupLayout() {
        naverMapView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.verticalEdges.equalTo(safeAreaLayoutGuide)
        }
        
        showLocationButton.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(24)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(24)
            make.width.height.equalTo(44)
        }
        
        listButtonStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(40)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(40)
        }
        
        compass.snp.makeConstraints { make in
            make.top.equalTo(showLocationButton.snp.bottom).offset(24)
            make.trailing.equalTo(showLocationButton.snp.trailing)
            make.width.height.equalTo(44)
        }
    }
    
    //MARK: - Private Func
    
    private func setupHierarchy() {
        naverMapView.addSubview(showLocationButton)
        listButtonStackView.addArrangedSubviews(questListButton, placeListButton)
        addSubviews(
            naverMapView,
            listButtonStackView,
            compass
        )
    }
    
    private func setupStyle() {
        showLocationButton.do { button in
            button.setImage(.btnDotScope, for: .normal)
            button.mapView = naverMapView.mapView
        }
        
        listButtonStackView.do { stackView in
            stackView.axis = .horizontal
            stackView.spacing = 14
            stackView.alignment = .fill
            stackView.distribution = .fillEqually
        }
    }
    
    private func setupInitialNaverMapView() {
        naverMapView.showZoomControls = false
        naverMapView.mapView.logoAlign = .leftTop
        naverMapView.showCompass = false
        naverMapView.mapView.positionMode = .compass
        
        compass.contentMode = .scaleAspectFit
        compass.mapView = naverMapView.mapView
        
        // 현재 위치 표시하는 마커 커스텀
        naverMapView.mapView.locationOverlay.subIcon = orangeTriangleArrowOverlayImage
        naverMapView.mapView.locationOverlay.subAnchor = CGPoint(x: 0.5, y: 1) // 기본값임
        naverMapView.mapView.locationOverlay.subIconWidth = 16
        naverMapView.mapView.locationOverlay.subIconHeight = 16
    }
    
}
