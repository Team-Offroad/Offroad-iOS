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
    let gradientView = UIView()
    let gradientLayer = CAGradientLayer()
    let markerTapBlocker = UIView()
    let shadingView = UIView()
    let tooltip: PlaceInfoTooltip = .init()
    let reloadPlaceButton = ShrinkableButton()
    let switchTrackingModeButton = UIButton()
    let listButtonStackView = UIStackView()
    let questListButton = ORBMapListButton(image: .iconListBullet, title: "퀘스트 목록")
    let placeListButton = ORBMapListButton(image: .iconPlaceMarker, title: "장소 목록")
    
    let naverMapView = NMFNaverMapView()
    let compass = NMFCompassView()
    private let triangleArrowOverlayImage = NMFOverlayImage(image: .icnQuestMapNavermapLocationOverlaySubIcon1)
    let locationOverlayImage = NMFOverlayImage(image: .icnQuestMapCircleInWhiteBorder)
    
    // tooltip의 centerYAnchor인 이유는 tooltip.layer.anchorPoint가 (0.5, 1)이기 때문
    lazy var tooltipCenterYConstraint = tooltip.centerYAnchor.constraint(equalTo: self.topAnchor, constant: 0)
    lazy var tooltipCenterXConstraint = tooltip.centerXAnchor.constraint(equalTo: self.leadingAnchor, constant: 0)
    
    var isTooltipShown: Bool = false
    private let shadingAnimator = UIViewPropertyAnimator(duration: 0.3, dampingRatio: 1)
    private let tooltipTransparencyAnimator = UIViewPropertyAnimator(duration: 0.2, dampingRatio: 1)
    private let tooltipShowingAnimator = UIViewPropertyAnimator(duration: 0.4, dampingRatio: 0.8)
    private let tooltipHidingAnimator = UIViewPropertyAnimator(duration: 0.25, dampingRatio: 1)
    
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
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        gradientLayer.frame = gradientView.bounds
        gradientView.layer.addSublayer(gradientLayer)
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
        
        gradientView.snp.makeConstraints { make in
            make.top.equalTo(listButtonStackView).offset(-63)
            make.horizontalEdges.bottom.equalToSuperview()
        }
        
        markerTapBlocker.snp.makeConstraints { make in
            make.top.equalTo(listButtonStackView)
            make.horizontalEdges.bottom.equalToSuperview()
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
        naverMapView.addSubviews(gradientView, markerTapBlocker, reloadPlaceButton, switchTrackingModeButton, shadingView, tooltip)
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
        
        gradientView.isUserInteractionEnabled = false
        gradientLayer.do { layer in
            layer.type = .axial
            layer.colors = [UIColor(hex: "5B5B5B")!.withAlphaComponent(0.55).cgColor, UIColor.clear.cgColor]
            layer.startPoint = CGPoint(x: 0, y: 1)
            layer.endPoint = CGPoint(x: 0, y: 0)
            layer.locations = [0, 1]
        }
        
        markerTapBlocker.do { view in
            view.backgroundColor = .clear
            view.isUserInteractionEnabled = false
        }
        
        reloadPlaceButton.do { button in
            button.setTitle("현 지도에서 검색", for: .normal)
            button.setImage(.icnReloadArrow, for: .normal)
            button.setImage(.icnReloadArrow, for: .disabled)
            button.configureBackgroundColorWhen(
                normal: .primary(.white),
                highlighted: .grayscale(.gray100),
                disabled: .grayscale(.gray100)
            )
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
    
    func showTooltip(completion: (() -> Void)? = nil) {
        tooltip.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        tooltip.alpha = 0
        layoutIfNeeded()
        tooltipHidingAnimator.stopAnimation(true)
        
        shadingAnimator.addAnimations { [weak self] in
            self?.shadingView.backgroundColor = .blackOpacity(.black25)
        }
        tooltipTransparencyAnimator.addAnimations { [weak self] in
            self?.tooltip.alpha = 1
        }
        tooltipShowingAnimator.addAnimations { [weak self] in
            self?.tooltip.transform = .identity
            self?.layoutIfNeeded()
        }
        tooltipShowingAnimator.addCompletion { _ in
            completion?()
        }
        
        isTooltipShown = true
        compass.isHidden = true
        shadingView.isUserInteractionEnabled = true
        tooltipTransparencyAnimator.startAnimation()
        shadingAnimator.startAnimation()
        tooltipShowingAnimator.startAnimation()
    }
    
    func hideTooltip(completion: (() -> Void)? = nil) {
        guard isTooltipShown else { return }
        tooltipShowingAnimator.stopAnimation(true)
        
        shadingAnimator.addAnimations { [weak self] in
            self?.shadingView.backgroundColor = .clear
        }
        tooltipHidingAnimator.addAnimations { [weak self] in
            self?.tooltip.transform = CGAffineTransform(scaleX: 0.05, y: 0.05)
        }
        tooltipHidingAnimator.addAnimations({ [weak self] in
            self?.tooltip.alpha = 0
        }, delayFactor: 0.3)
        tooltipHidingAnimator.addCompletion { [weak self] _ in
            self?.tooltip.configure(with: nil)
            self?.shadingView.isUserInteractionEnabled = false
            completion?()
        }
        isTooltipShown = false
        compass.isHidden = false
        shadingAnimator.startAnimation()
        tooltipHidingAnimator.startAnimation()
    }
    
    /// 지도의 카메라를 지정된 좌표(`NMGLatLng`)로 이동시키는 함수
    /// - Parameters:
    ///   - coordinate: 이동하고자 하는 좌표값. `NMGLatLng` 타입
    ///   - animationCurve: 지도가 움직일 때의 애니메이션 종류. NMFCameraUpdateAnimation 타입.
    ///   - animationDuration: 애니메이션 시간. 0으로 설정할 경우, 애니메이션 없이 바로 이동. 기본값은 NAVER Map iOS SDK에서 설정하는 0.2
    ///   - reason: 카메라 이동에 사용될 `NMFCameraUpdate` 타입의 `reason` 속성에 할당할 값. 기본값은 `NMFMapChangedByDeveloper`이며, -1에 해당. (개발자가 API를 호출해 카메라가 움직였음을 의미)
    ///   - completion: 카메라 이동이 완료되었을 때 호출되는 콜백 블록. 애니메이션이 있으면 완전히 끝난 후에 호출됩니다. `Bool` 타입의 매개변수는 카메라 이동이 완료되기 전에 다른 카메라 이동이 호출되거나 사용자가 제스처로 지도를 조작한 경우 `true`입니다.
    func moveCamera(
        scrollTo coordinate: NMGLatLng,
        animationCurve: NMFCameraUpdateAnimation = .easeOut,
        // NAVER Map iOS SDK에서 지정하는 기본값이 0.2
        animationDuration: TimeInterval = 0.2,
        reason: Int32 = Int32(NMFMapChangedByDeveloper),
        completion: ((Bool) -> Void)? = nil
    ) {
        let cameraUpdate = NMFCameraUpdate(scrollTo: coordinate)
        cameraUpdate.reason = reason
        cameraUpdate.animation = animationCurve
        cameraUpdate.animationDuration = animationDuration
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.naverMapView.mapView.moveCamera(cameraUpdate) { isCancelled in
                completion?(isCancelled)
            }
        }
    }
    
    /// 지도의 카메라를 현재 위치에서 `delta` 포인트만큼 이동시키는 함수
    /// - Parameters:
    ///   - delta: 이동할 거리. 가로, 세로로 `pt` 단위이며 각각의 값을 `x`, `y` 속성으로 갖는 `CGPoint` 값.
    ///   - animationCurve: 지도가 움직일 때의 애니메이션 종류. NMFCameraUpdateAnimation 타입.
    ///   - animationDuration: 애니메이션 시간. 0으로 설정할 경우, 애니메이션 없이 바로 이동. 기본값은 NAVER Map iOS SDK에서 설정하는 0.2
    ///   - reason: 카메라 이동에 사용될 `NMFCameraUpdate` 타입의 `reason` 속성에 할당할 값. 기본값은 `NMFMapChangedByDeveloper`이며, -1에 해당. (개발자가 API를 호출해 카메라가 움직였음을 의미)
    ///   - completion: 카메라 이동이 완료되었을 때 호출되는 콜백 블록. 애니메이션이 있으면 완전히 끝난 후에 호출됩니다. `Bool` 타입의 매개변수는 카메라 이동이 완료되기 전에 다른 카메라 이동이 호출되거나 사용자가 제스처로 지도를 조작한 경우 `true`입니다.
    func moveCamera(
        scrollBy delta: CGPoint,
        animationCurve: NMFCameraUpdateAnimation = .easeOut,
        // NAVER Map iOS SDK에서 지정하는 기본값이 0.2
        animationDuration: TimeInterval = 0.2,
        reason: Int32 = Int32(NMFMapChangedByDeveloper),
        completion: ((Bool) -> Void)? = nil
    ) {
        let cameraUpdate = NMFCameraUpdate(scrollBy: delta)
        cameraUpdate.reason = reason
        cameraUpdate.animation = animationCurve
        cameraUpdate.animationDuration = animationDuration
        naverMapView.mapView.moveCamera(cameraUpdate) { isCancelled in
            completion?(isCancelled)
        }
    }
    
}
