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
    
    let customNavigationBar = UIView()
    let navigationBarSeparator = UIView()
    let titleLabel = UILabel()
    let reloadPlaceButton = UIButton()
    let switchTrackingModeButton = UIButton()
    private let listButtonStackView = UIStackView()
    let questListButton = QuestMapListButton(image: .iconListBullet, title: "퀘스트 목록")
    let placeListButton = QuestMapListButton(image: .iconPlaceMarker, title: "장소 목록")
    
    let naverMapView = NMFNaverMapView()
    private let compass = NMFCompassView()
    private let orangeTriangleArrowOverlayImage = NMFOverlayImage(image: .icnNavermapLocationOverlaySubIcon)
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
    
    //MARK: - Layout Func
    
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
            make.top.equalToSuperview().inset(123)
            make.bottom.equalToSuperview()
        }
        
        switchTrackingModeButton.snp.makeConstraints { make in
            make.top.equalTo(customNavigationBar.snp.bottom).offset(24)
            make.trailing.equalTo(safeAreaLayoutGuide).inset(24)
            make.width.height.equalTo(44)
        }
        
        listButtonStackView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.horizontalEdges.equalTo(safeAreaLayoutGuide).inset(40)
            make.bottom.equalTo(safeAreaLayoutGuide).inset(59)
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
            button.setImage(.icnReloadArrow, for: .disabled)
            button.configureBackgroundColorWhen(normal: .primary(.white), highlighted: .grayscale(.gray300), disabled: .grayscale(.gray200))
            button.configureTitleFontWhen(normal: .pretendardFont(ofSize: 13.2, weight: .medium))
            button.setTitleColor(.grayscale(.gray400), for: .normal)
            button.setTitleColor(.grayscale(.gray400), for: .highlighted)
            button.setTitleColor(.grayscale(.gray400), for: .disabled)
            button.clipsToBounds = true
            button.layer.cornerRadius = 5.5
            button.layer.borderWidth = 1
            button.layer.borderColor = UIColor.grayscale(.gray200).cgColor
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
        customizeLocationOverlaySubIcon(mode: .compass)
    }
    
    //MARK: - Func
    
    func customizeLocationOverlaySubIcon(mode: NMFMyPositionMode) {
        switch mode {
        case .normal:
            naverMapView.mapView.locationOverlay.subIcon = nil
        case .compass, .direction:
            // 현재 위치 표시하는 마커 커스텀
            naverMapView.mapView.locationOverlay.icon = orangeLocationOverlayImage
            naverMapView.mapView.locationOverlay.do { overlay in
                overlay.subIcon = orangeTriangleArrowOverlayImage
                overlay.subAnchor = CGPoint(x: 0.5, y: 1) // 기본값임
                overlay.subIconWidth = 8
                overlay.subIconHeight = 17.5
                overlay.circleColor = .sub(.sub).withAlphaComponent(0.25)
            }
        default:
            break
        }
    }
    
}
