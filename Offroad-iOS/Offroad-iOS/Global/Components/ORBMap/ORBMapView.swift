//
//  ORBMapView.swift
//  Offroad-iOS
//
//  Created by 김민성 on 4/8/25.
//

import CoreLocation
import UIKit

import NMapsMap
import RxSwift
import RxCocoa

final class ORBMapView: NMFNaverMapView {
    
    enum ORBMapTrackingMode {
        case none
        case normal
        case direction
        case compass
    }
    
    enum LocationAuthorizationCase: Int {
        case notDetermined = 0
        case fullAccuracy
        case reducedAccuracy
        case denied
        case restricted
        case servicesDisabled
    }
    
    /// 현재 선택된 장소의 마커.
    var selectedMarker: ORBNMFMarker? = nil
    
    /// 현재 선택된 장소의 지도 화면상의 위치(CGPoint)
    private var selectedMarkerPoint: CGPoint? {
        guard let selectedMarker else { return nil }
        return mapView.projection.point(from: selectedMarker.position)
    }
    
    private let locationManager = CLLocationManager()
    
    var trackingMode: ORBMapTrackingMode = .none {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.setTrackingMode(to: self.trackingMode)
            }
        }
    }
    
    private let tooltip = PlaceInfoTooltip()
    private let shadingView = UIView()
    private lazy var tooltipHelper = PlaceInfoTooltipHelper(tooltip: tooltip, shadingView: shadingView)
    
    private let locationOverlayImage = NMFOverlayImage(image: .icnQuestMapCircleInWhiteBorder)
    private let triangleArrowOverlayImage = NMFOverlayImage(image: .icnQuestMapNavermapLocationOverlaySubIcon1)
    
    // tooltip의 centerYAnchor인 이유는 tooltip.layer.anchorPoint가 (0.5, 1)이기 때문
    private lazy var tooltipPointYConstraint = tooltip.centerYAnchor.constraint(equalTo: self.topAnchor, constant: 0)
    private lazy var tooltipPointXConstraint = tooltip.centerXAnchor.constraint(equalTo: self.leadingAnchor, constant: 0)
    
    private var disposeBag = DisposeBag()
    let exploreButtonTapped = PublishRelay<Void>()
    let onMovieCameraIdle = PublishRelay<Void>()
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupTooltipAction()
        initialSetup()
        setupDelegates()
        setupGestureRecognizers()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


// Initial Settings
extension ORBMapView {
    
    private func setupStyle() {
        shadingView.isUserInteractionEnabled = false
        tooltip.isHidden = true
    }
    
    private func setupHierarchy() {
        addSubviews(shadingView, tooltip)
    }
    
    private func setupLayout() {
        shadingView.snp.makeConstraints { $0.edges.equalToSuperview() }
        tooltipPointXConstraint.isActive = true
        tooltipPointYConstraint.isActive = true
    }
    
    private func setupTooltipAction() {
        tooltip.closeButton.rx.tap.bind(onNext: { [weak self] in
            self?.hideTooltipAndUnselectMarker()
        }).disposed(by: disposeBag)
        
        tooltip.exploreButton.rx.tap.bind(onNext: { [weak self] in
            self?.exploreButtonTapped.accept(())
        }).disposed(by: disposeBag)
    }
    
    private func initialSetup() {
        // 네이버 로고 관련
        mapView.logoAlign = .leftTop
        mapView.logoInteractionEnabled = true
        
        mapView.positionMode = .normal
        mapView.locationOverlay.icon = locationOverlayImage
        showZoomControls = false
        showCompass = false
        customizeLocationOverlaySubIcon(mode: .compass)
        
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
    }
    
    private func setupDelegates() {
        locationManager.delegate = self
        mapView.addCameraDelegate(delegate: self)
    }
    
    private func setupGestureRecognizers() {
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event.subscribe(onNext: { [weak self] gesture in
            self?.hideTooltipAndUnselectMarker()
        }).disposed(by: disposeBag)
        shadingView.addGestureRecognizer(tapGesture)
    }
    
}

// MARK: - Private Func

private extension ORBMapView {
    
    private func customizeLocationOverlaySubIcon(mode: NMFMyPositionMode) {
        switch mode {
        case .normal:
            mapView.locationOverlay.subIcon = nil
        case .compass, .direction:
            // 현재 위치 표시하는 마커 커스텀
            mapView.locationOverlay.icon = locationOverlayImage
            mapView.locationOverlay.do { overlay in
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
    
    private func setTrackingMode(to mode: ORBMapTrackingMode) {
        switch mode {
        case .none:
            mapView.locationOverlay.hidden = true
            return
            
        case .normal:
            guard (locationManager.location?.coordinate) != nil else { return }
            mapView.locationOverlay.hidden = false
            mapView.positionMode = .normal
            
        case .direction:
            guard let currentCoordinate = locationManager.location?.coordinate else { return }
            mapView.locationOverlay.hidden = false
            moveCamera(scrollTo: NMGLatLng(from: currentCoordinate), reason: 1) { [weak self] isCanceled in
                if !isCanceled {
                    self?.mapView.positionMode = .direction
                }
            }
            
        case .compass:
            guard let currentHeading = locationManager.heading?.trueHeading else { return }
            mapView.locationOverlay.hidden = false
            mapView.locationOverlay.heading = currentHeading
            mapView.locationOverlay.icon = locationOverlayImage
            
            let cameraUpdate = NMFCameraUpdate(heading: currentHeading)
            cameraUpdate.reason = 10
            cameraUpdate.animation = .easeOut
            mapView.moveCamera(cameraUpdate)
            mapView.locationOverlay.icon = locationOverlayImage
            
        @unknown default:
            return
        }
    }
    
    private func setTooltipPoint(point: CGPoint) {
        tooltipPointXConstraint.constant = point.x
        // 17 뺀 것은 툴팁 아래 화살표 끝 위치를 마커의 중앙으로 설정하기 위함.
        tooltipPointYConstraint.constant = point.y - 17
        layoutIfNeeded()
    }
    
    private func updateLocationOverlayHeading(_ newHeading: CLHeading) {
        mapView.locationOverlay.heading = newHeading.trueHeading
    }
    
    private func updateCameraHeading(_ newHeading: CLHeading) {
        let cameraUpdate = NMFCameraUpdate(heading: newHeading.trueHeading)
        cameraUpdate.reason = 10
        cameraUpdate.animation = .easeOut
        mapView.moveCamera(cameraUpdate)
        mapView.locationOverlay.icon = locationOverlayImage
    }
    
}

// MARK: - Public Func

extension ORBMapView {
    
    public func configureTooltip(place: RegisteredPlaceInfo) {
        tooltip.configure(with: place)
    }
    
    public func showSelectedMarkerTooltip() {
        guard let selectedMarker else { return }
        guard let selectedMarkerPoint else { return }
        setTooltipPoint(point: selectedMarkerPoint)
        tooltipHelper.showTooltip()
        
        let tilt = mapView.cameraPosition.tilt
        if tilt > 30 {
            moveCamera(scrollTo: selectedMarker.position, animationCurve: .fly, animationDuration: 0.5)
        } else {
            let mapSize = mapView.frame.size
            let delta = tooltipHelper.caculateDeltaToShowTooltip(point: selectedMarkerPoint,
                                                             at: mapSize,
                                                             tooltipSize: tooltip.frame.size,
                                                             contentInset: 20)
            moveCamera(scrollBy: delta, animationDuration: 0.3)
        }
    }
    
    /// 지도의 카메라를 지정된 좌표(`NMGLatLng`)로 이동시키는 함수
    /// - Parameters:
    ///   - coordinate: 이동하고자 하는 좌표값. `NMGLatLng` 타입
    ///   - animationCurve: 지도가 움직일 때의 애니메이션 종류. NMFCameraUpdateAnimation 타입.
    ///   - animationDuration: 애니메이션 시간. 0으로 설정할 경우, 애니메이션 없이 바로 이동. 기본값은 NAVER Map iOS SDK에서 설정하는 0.2
    ///   - reason: 카메라 이동에 사용될 `NMFCameraUpdate` 타입의 `reason` 속성에 할당할 값. 기본값은 `NMFMapChangedByDeveloper`이며, -1에 해당. (개발자가 API를 호출해 카메라가 움직였음을 의미)
    ///   - completion: 카메라 이동이 완료되었을 때 호출되는 콜백 블록. 애니메이션이 있으면 완전히 끝난 후에 호출됩니다. `Bool` 타입의 매개변수는 카메라 이동이 완료되기 전에 다른 카메라 이동이 호출되거나 사용자가 제스처로 지도를 조작한 경우 `true`입니다.
    public func moveCamera(
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
            self?.mapView.moveCamera(cameraUpdate) { isCancelled in
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
    public func moveCamera(
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
        mapView.moveCamera(cameraUpdate) { isCancelled in
            completion?(isCancelled)
        }
    }
    
    public func hideTooltipAndUnselectMarker() {
        tooltipHelper.hideTooltip { [weak self] in self?.selectedMarker = nil }
    }
    
}

//MARK: - NMFMapViewCameraDelegate

extension ORBMapView: NMFMapViewCameraDelegate {
    
    /**
     reason
     
     - 0: 개발자가 API를 호출해 카메라가 움직였음을 나타내는 값. (`NMFMapChangedByDeveloper`)
     - -1: 사용자의 제스처로 인해 카메라가 움직였음을 나타내는 값. (`NMFMapChangedByGesture`)
     - -2: 사용자의 버튼 선택으로 인해 카메라가 움직였음을 나타내는 값. (`NMFMapChangedByControl`)
        여기서 버튼이란 - 네이버 지도 API에서 기본으로 제공하는 버튼(Control)을 말하는 것 같음.(예: 나침반 버튼)
     - -3: 위치 정보 갱신으로 카메라가 움직였음을 나타내는 값. (`NMFMapChangedByLocation`)
     */
    func mapView(_ mapView: NMFMapView, cameraWillChangeByReason reason: Int, animated: Bool) {
        switch reason {
        // API 호출로 카메라 이동
        case 0:
            trackingMode = .normal
        // 제스처 사용으로 카메라 이동
        case -1:
            trackingMode = .normal
            guard let selectedMarkerPoint else { return }
            setTooltipPoint(point: selectedMarkerPoint)
        // 버튼 선택으로 카메라 이동
        case -2:
            trackingMode = .normal
            let orangeLocationOverlayImage = locationOverlayImage
            mapView.locationOverlay.icon = orangeLocationOverlayImage
            customizeLocationOverlaySubIcon(mode: .compass)
            
            guard selectedMarker != nil else { return }
            // 툴팁 숨기기
            hideTooltipAndUnselectMarker()
        default:
            return
        }
    }
    
    func mapView(_ mapView: NMFMapView, cameraIsChangingByReason reason: Int) {
        guard let selectedMarkerPoint else { return }
        setTooltipPoint(point: selectedMarkerPoint)
    }
    
    func mapView(_ mapView: NMFMapView, cameraDidChangeByReason reason: Int, animated: Bool) {
        mapView.locationOverlay.icon = locationOverlayImage
        
        switch reason {
        // API 호출로 카메라 이동
        case 0:
            return
        // 핸드폰을 돌려서, 혹은 현재 위치 버튼 선택 후 위치 트래킹 활성화로 인해 카메라 방향이 회전한 경우
        case 10:
            mapView.positionMode = .direction
        default:
            return
        }
    }
    
    func mapViewCameraIdle(_ mapView: NMFMapView) {
        onMovieCameraIdle.accept(())
    }
    
}

// MARK: - CLLocationManagerDelegate

extension ORBMapView: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        switch trackingMode {
        case .none:
            return
        case .normal, .direction:
            updateLocationOverlayHeading(newHeading)
        case .compass:
            updateLocationOverlayHeading(newHeading)
            updateCameraHeading(newHeading)
        @unknown default:
            return
        }
    }
    
}
