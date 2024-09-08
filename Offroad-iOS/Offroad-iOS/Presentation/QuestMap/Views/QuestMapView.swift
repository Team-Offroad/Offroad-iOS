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

enum TrackingMode {
    case normal
    case compass
}

class QuestMapView: UIView {
    
    //MARK: - UI Properties
    
    let customNavigationBar = UIView()
    let navigationBarSeparator = UIView()
    let titleLabel = UILabel()
    let reloadPlaceButton = UIButton()
    let switchTrackingModeButton = UIButton()
    private let listButtonStackView = UIStackView()
    let questListButton = QuestMapListButton(image: .iconListBullet, title: "퀘스트 목록")
    let placeListButton = QuestMapListButton(image: .iconPlaceMarker, title: "장소 목록")
    
    let naverMapView = NMFNaverMapView()
    let compass = NMFCompassView()
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
        customNavigationBar.snp.makeConstraints { make in
            make.top.horizontalEdges.equalToSuperview()
            make.height.equalTo(123)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.leading.equalTo(safeAreaLayoutGuide).inset(24)
            make.bottom.equalToSuperview().inset(20)
        }
        
        navigationBarSeparator.snp.makeConstraints { make in
            make.top.equalTo(customNavigationBar.snp.bottom)
            make.horizontalEdges.equalToSuperview()
            make.height.equalTo(1)
        }
        
        reloadPlaceButton.snp.makeConstraints { make in
            make.top.equalTo(customNavigationBar.snp.bottom).offset(23)
            make.centerX.equalToSuperview()
            make.width.equalTo(136)
            make.height.equalTo(33)
        }
        
        naverMapView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            //make.verticalEdges.equalTo(safeAreaLayoutGuide)
            make.verticalEdges.equalToSuperview()
        }
        
        switchTrackingModeButton.snp.makeConstraints { make in
            make.top.equalTo(customNavigationBar.snp.bottom).offset(24)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(24)
            make.width.height.equalTo(44)
        }
        
        listButtonStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(40)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(40)
        }
        
        compass.snp.makeConstraints { make in
            make.top.equalTo(switchTrackingModeButton.snp.bottom).offset(24)
            make.trailing.equalTo(switchTrackingModeButton.snp.trailing)
            make.width.height.equalTo(44)
        }
    }
    
    //MARK: - Private Func
    
    private func setupHierarchy() {
        naverMapView.addSubviews(reloadPlaceButton, switchTrackingModeButton)
        listButtonStackView.addArrangedSubviews(questListButton, placeListButton)
        customNavigationBar.addSubview(titleLabel)
        addSubviews(
            naverMapView,
            listButtonStackView,
            compass,
            customNavigationBar,
            navigationBarSeparator
        )
    }
    
    private func setupStyle() {
        customNavigationBar.do { view in
            view.backgroundColor = .main(.main1)
        }
        
        titleLabel.do { label in
            label.textColor = .main(.main2)
            label.font = .offroad(style: .iosSubtitle2Bold)
            label.text = "어디를 탐험해 볼까요?"
        }
        
        navigationBarSeparator.do { view in
            view.backgroundColor = .grayscale(.gray100)
        }
        
        reloadPlaceButton.do { button in
            button.setTitle("현 지도에서 검색", for: .normal)
            button.setImage(.icnReloadArrow, for: .normal)
            button.setBackgroundColor(.primary(.white), for: .normal)
            button.setTitleColor(.grayscale(.gray400), for: .normal)
            button.setTitleColor(.primary(.black), for: .highlighted)
            button.clipsToBounds = true
            button.layer.cornerRadius = 5.5
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.grayscale(.gray200).cgColor
            button.titleLabel?.font = UIFont.pretendardFont(ofSize: 13.2, weight: .medium)
        }
        
        switchTrackingModeButton.do { button in
            button.setImage(.btnDotScope, for: .normal)
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
        naverMapView.mapView.logoInteractionEnabled = false
        
        compass.contentMode = .scaleAspectFit
        compass.mapView = naverMapView.mapView
        
        // 현재 위치 표시하는 마커 커스텀
        naverMapView.mapView.locationOverlay.icon = orangeLocationOverlayImage
        customizeLocationOverlaySubIcon(state: .compass)
    }
    
    func customizeLocationOverlaySubIcon(state: TrackingMode) {
        switch state {
        case .normal:
            naverMapView.mapView.locationOverlay.subIcon = nil
        case .compass:
            // 현재 위치 표시하는 마커 커스텀
            naverMapView.mapView.locationOverlay.icon = orangeLocationOverlayImage
            naverMapView.mapView.locationOverlay.do { overlay in
                overlay.subIcon = orangeTriangleArrowOverlayImage
                overlay.subAnchor = CGPoint(x: 0.5, y: 1) // 기본값임
                overlay.subIconWidth = 16
                overlay.subIconHeight = 16
                overlay.circleColor = .sub(.sub).withAlphaComponent(0.07)
            }
        }
    }
    
}
