//
//  ORBMapView.swift
//  Offroad-iOS
//
//  Created by 김민성 on 2024/07/07.
//

import UIKit

import NMapsMap
import SnapKit
import Then

class ORBMapView: UIView {
    
    //MARK: - UI Properties
    
    let customNavigationBar = UIView()
    let navigationBarSeparator = UIView()
    let titleLabel = UILabel()
    let shadingView = UIView()
    let tooltip: PlaceInfoTooltip = .init()
    let reloadPlaceButton = UIButton()
    let switchTrackingModeButton = UIButton()
    let listButtonStackView = UIStackView()
    let questListButton = QuestMapListButton(image: .iconListBullet, title: "퀘스트 목록")
    let placeListButton = QuestMapListButton(image: .iconPlaceMarker, title: "장소 목록")
    
    let naverMapView = NMFNaverMapView()
    let compass = NMFCompassView()
    private let triangleArrowOverlayImage = NMFOverlayImage(image: .icnQuestMapNavermapLocationOverlaySubIcon1)
    let locationOverlayImage = NMFOverlayImage(image: .icnQuestMapCircleInWhiteBorder)
    
    // tooltip의 centerYAnchor인 이유는 tooltip.layer.anchorPoint가 (0.5, 1)이기 때문
    lazy var tooltipCenterYConstraint = tooltip.centerYAnchor.constraint(equalTo: self.topAnchor, constant: 0)
    lazy var tooltipCenterXConstraint = tooltip.centerXAnchor.constraint(equalTo: self.leadingAnchor, constant: 0)
    
    var tooltipAnchorPoint: CGPoint = .zero {
        didSet {
            updateTooltipPosition()
        }
    }
    
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

extension ORBMapView {
    
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
        
        shadingView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        
        tooltipCenterYConstraint.isActive = true
        tooltipCenterXConstraint.isActive = true
        
        reloadPlaceButton.snp.makeConstraints { make in
            make.top.equalTo(customNavigationBar.snp.bottom).offset(23)
            make.centerX.equalToSuperview()
            make.width.equalTo(136)
            make.height.equalTo(33)
        }
        
        naverMapView.snp.makeConstraints { make in
            make.horizontalEdges.equalToSuperview()
            make.top.equalTo(navigationBarSeparator.snp.bottom)
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
            make.height.greaterThanOrEqualTo(48)
        }
        
        compass.snp.makeConstraints { make in
            make.top.equalTo(switchTrackingModeButton.snp.bottom).offset(24)
            make.trailing.equalTo(switchTrackingModeButton.snp.trailing)
            make.width.height.equalTo(44)
        }
    }
    
    //MARK: - Private Func
    
    private func setupHierarchy() {
        naverMapView.addSubviews(reloadPlaceButton, switchTrackingModeButton, shadingView, tooltip)
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
        
        shadingView.do { view in
            view.isUserInteractionEnabled = false
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
        naverMapView.mapView.logoInteractionEnabled = true
        
        compass.contentMode = .scaleAspectFit
        compass.mapView = naverMapView.mapView
        
        // 현재 위치 표시하는 마커 커스텀
        naverMapView.mapView.locationOverlay.icon = locationOverlayImage
        customizeLocationOverlaySubIcon(mode: .compass)
    }
    
    private func updateTooltipPosition() {
        // 17 뺀 것은 툴팁 아래 화살표 끝 위치를 마커의 중앙으로 설정하기 위함.
        tooltipCenterYConstraint.constant = tooltipAnchorPoint.y - 17
        tooltipCenterXConstraint.constant = tooltipAnchorPoint.x
        layoutIfNeeded()
    }
    
    //MARK: - Func
    
    func customizeLocationOverlaySubIcon(mode: NMFMyPositionMode) {
        switch mode {
        case .normal:
            naverMapView.mapView.locationOverlay.subIcon = nil
        case .compass, .direction:
            // 현재 위치 표시하는 마커 커스텀
            naverMapView.mapView.locationOverlay.icon = locationOverlayImage
            naverMapView.mapView.locationOverlay.do { overlay in
                overlay.subIcon = triangleArrowOverlayImage
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
