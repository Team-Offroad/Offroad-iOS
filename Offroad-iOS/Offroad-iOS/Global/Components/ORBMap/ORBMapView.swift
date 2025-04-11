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

enum ORBMapError: LocalizedError {
    case EmptyTooltip
    
    public var errorDescription: String? {
        switch self {
        case .EmptyTooltip:
            return "Tooltip doesn't contain marker infomation"
        }
    }
}

final class ORBMapView: NMFNaverMapView {
    
    /// ORBMapView에서 위치 추적 모드
    enum ORBMapTrackingMode {
        /// 위치를 추적하지 않는 모드. (내 위치 오버레이가 숨겨짐)
        case none
        /// 위치 오버레이를 띄우나, 지도가 따라서 이동하지는 않는 모드.
        case normal
        /// 위치 오버레이가 뜨고, 지도의 카메라가 내 위치를 따라 이동하는 모드.
        case direction
        /// 위치 오버레이가 뜨고, 지도의 카메라가 내 위치와 방향을 따라 이동하는 모드.
        case compass
    }
    
    /// 지도의 위치 추적 모드. 값을 할당하는 즉시 위치 추적 모드가 변경됨.
    var trackingMode: ORBMapTrackingMode = .none {
        didSet {
            DispatchQueue.main.async { [weak self] in
                guard let self else { return }
                self.setTrackingMode(to: self.trackingMode)
            }
        }
    }
    
    private let locationManager = CLLocationManager()
    
    /// 툴팁이 떠 있을 때 툴팁 아래의 배경을 터치할 수 있는지 여부. 기본값은 `true`
    var shouldBlockBackgroundTouch: Bool = true
    
    /// 툴팁이 떠 있을 때 지도가 움직이면 툴팁이 닫힐 지 여부. 기본값은 `true`
    ///
    /// 사용자가 스크롤하는 경우에만 적용되며, `disableScrollWhenTooltipShown` 이 `true`인 경우 이 값은 무시됩니다.
    var hideTooltipWhenScrolling: Bool = true
    
    /// 현재 선택된 장소의 마커. 툴팁이 뜰 때 선택된 마커의 위치에 뜨게 됩니다. 선택된 장소가 없으면 `nil`을 반환.
    ///
    /// - Note: 선택된 마커의 툴팁을 띄우고자 할 때 마커의 touchHandler(`NMFOverlayTouchHandler?` 타입)  콜백 함수로 해당 마커를 이 속성에 할당해 주세요.
    /// 그렇지 않을 경우 툴팁이 선택된 마커에 뜨지 않습니다.
//    var selectedMarker: ORBNMFMarker? = nil
    
    let tooltip = PlaceInfoTooltip()
    
    private let shadingView = UIView()
    private lazy var tooltipHelper = PlaceInfoTooltipHelper(tooltip: tooltip, shadingView: shadingView)
    
    // 위치 오버레이 커스텀 디자인 관련 속성
    private let locationOverlayImage = NMFOverlayImage(image: .icnQuestMapCircleInWhiteBorder)
    private let triangleArrowOverlayImage = NMFOverlayImage(image: .icnQuestMapNavermapLocationOverlaySubIcon1)
    
    // tooltip의 bottomeAnchore가 아닌 centerYAnchor의 constant가 지도 뷰에서 장소의 y좌표에 해당.
    // tooltip의 centerYAnchor인 이유는 tooltip.layer.anchorPoint가 (0.5, 1)이기 때문
    private lazy var tooltipPointYConstraint = tooltip.centerYAnchor.constraint(equalTo: self.topAnchor, constant: 0)
    private lazy var tooltipPointXConstraint = tooltip.centerXAnchor.constraint(equalTo: self.leadingAnchor, constant: 0)
    
    // MARK: - Rx Properties
    
    private var disposeBag = DisposeBag()
    let exploreButtonTapped = PublishSubject<RegisteredPlaceInfo>()
    let onMapViewCameraIdle = PublishRelay<Void>()
    let tooltipWillShow = PublishRelay<Void>()
    let tooltipDidShow = PublishRelay<Void>()
    let tooltipWillHide = PublishRelay<Void>()
    let tooltipDidHide = PublishRelay<Void>()
    
    // MARK: - Life Cycle
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        
        setupStyle()
        setupHierarchy()
        setupLayout()
        setupTooltipAction()
        initialSetup()
        customizeLocationOverlay()
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
            self?.hideTooltip()
        }).disposed(by: disposeBag)
        
        tooltip.exploreButton.rx.tap.bind(onNext: { [weak self] in
            guard let self else { return }
            if let selectedMarker = tooltip.marker {
                self.exploreButtonTapped.onNext(selectedMarker.placeInfo)
            } else {
                self.exploreButtonTapped.onError(ORBMapError.EmptyTooltip)
            }
        }).disposed(by: disposeBag)
    }
    
    private func initialSetup() {
        // 네이버 로고 관련
        mapView.logoAlign = .leftTop
        mapView.logoInteractionEnabled = true
        
        mapView.positionMode = .normal
        showZoomControls = false
        showCompass = false
        
        locationManager.startUpdatingLocation()
        locationManager.startUpdatingHeading()
    }
    
    private func customizeLocationOverlay() {
        mapView.locationOverlay.do { overlay in
            overlay.icon = locationOverlayImage
            overlay.subIcon = triangleArrowOverlayImage
            overlay.subAnchor = CGPoint(x: 0.5, y: 1) // 기본값임
            overlay.subIconWidth = 8
            overlay.subIconHeight = 17.5
            overlay.circleColor = .sub(.sub).withAlphaComponent(0.25)
        }
    }
    
    private func setupDelegates() {
        locationManager.delegate = self
        mapView.addCameraDelegate(delegate: self)
        mapView.touchDelegate = self
    }
    
    private func setupGestureRecognizers() {
        let tapGesture = UITapGestureRecognizer()
        tapGesture.rx.event.subscribe(onNext: { [weak self] gesture in
            self?.hideTooltip()
        }).disposed(by: disposeBag)
        shadingView.addGestureRecognizer(tapGesture)
    }
    
}

// MARK: - Private Func

private extension ORBMapView {
    
    /// 위치 추적 모드가 설정됐을 때 호출되는 함수.
    /// - Parameter mode: 설정된 위치 추적 모드
    /// - Description: 이 함수는 위치 추적 모드가 설정되었을 때 초기 화면을 설정하는 함수이며, 위치 추적 동작 자체를 구현하는 것은 아님.
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
            moveCamera(scrollTo: NMGLatLng(from: currentCoordinate), reason: 1) { [weak self] isCanceled in
                if !isCanceled {
                    self?.mapView.positionMode = .direction
                }
            }
            mapView.locationOverlay.icon = locationOverlayImage
            mapView.locationOverlay.hidden = false
            
        case .compass:
            guard let currentHeading = locationManager.heading else { return }
            mapView.locationOverlay.hidden = false
            mapView.locationOverlay.heading = currentHeading.trueHeading
            updateCameraHeading(currentHeading)
            
        @unknown default:
            return
        }
    }
    
    /// 툴팁이 표시할 위치를 설정하는 함수.
    /// - Parameter point: 툴팁을 띄울 장소의 지도 뷰 상에서 위치(`CGPoint`)
    private func updateTooltipPoint(_ point: CGPoint) {
        tooltipPointXConstraint.constant = point.x
        // 17 뺀 것은 툴팁 아래 화살표 끝 위치를 마커의 중앙으로 설정하기 위함.
        tooltipPointYConstraint.constant = point.y - 17
        layoutIfNeeded()
    }
    
    /// 위치 오버레이의 방향을 설정하는 함수.
    /// - Parameter newHeading: 위치 오버레이의 화살표가 가리킬 방향
    private func updateLocationOverlayHeading(_ newHeading: CLHeading) {
        mapView.locationOverlay.heading = newHeading.trueHeading
    }
    
    /// 지도 카메라의 방향을 설정하는 함수.
    /// - Parameter newHeading: 지도 카메라가 회전할 방향. 북쪽이 화면의 위로 가도록 구현됨.
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
    
    /// 특정 마커에 툴팁을 띄우는 함수.
    public func showTooltip(_ marker: ORBNMFMarker) {
        tooltip.setMarker(marker)
        guard let tooltipPoint = tooltip.getPoint(in: mapView) else { return }
        
        shadingView.isUserInteractionEnabled = shouldBlockBackgroundTouch ? true : false
        updateTooltipPoint(tooltipPoint)
        tooltipWillShow.accept(())
        tooltipHelper.showTooltip { [weak self] in
            self?.tooltipDidShow.accept(())
        }
        
        let tilt = mapView.cameraPosition.tilt
        if tilt > 30 {
            // 툴팁을 띄울 때 카메라 이동의 reason은 -4
            moveCamera(scrollTo: tooltip.marker!.position, animationCurve: .fly, animationDuration: 0.5, reason: -4)
        } else {
            let mapSize = mapView.frame.size
            let delta = tooltipHelper.caculateDeltaToShowTooltip(
                point: tooltipPoint,
                at: mapSize,
                tooltipSize: tooltip.frame.size,
                contentInset: 20)
            // 툴팁을 띄울 때 카메라 이동의 reason은 -4
            moveCamera(scrollBy: delta, animationDuration: 0.3, reason: -4)
        }
    }
    
    /// 툴팁을 숨기고 선택된 마커의 선택을 해제하는 함수.
    public func hideTooltip() {
        tooltipWillHide.accept(())
        shadingView.isUserInteractionEnabled = false
        tooltipHelper.hideTooltip { [weak self] in
            self?.tooltipDidHide.accept(())
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
        mapView.moveCamera(cameraUpdate) { isCancelled in
            completion?(isCancelled)
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
        if reason != -4 && hideTooltipWhenScrolling {
            hideTooltip()
        }
        switch reason {
        // tracking mode 변경 버튼을 눌렀을 때 카메라 이동
        case 1:
            // tracking mode 변경 버튼을 눌렀을 때는 이미 trackingMode에 값을 할당한 상황이므로, 별도 trackingMode에 새 값 할당 X.
            return
        // API 호출로 카메라 이동
        case 0:
            trackingMode = .normal
        // 제스처 사용으로 카메라 이동
        case -1:
            trackingMode = .normal
            guard let tooltipPoint = tooltip.getPoint(in: mapView) else { return }
            updateTooltipPoint(tooltipPoint)
        // 버튼 선택으로 카메라 이동
        case -2:
            trackingMode = .normal
            mapView.locationOverlay.icon = locationOverlayImage
        // 위치 정보 갱신으로 카메라 이동
        case -3:
            // 위치 정보 갱신으로 인한 경우는 trackingMode 변화 없음.
            return
        // 툴팁이 뜰 때 카메라 이동
        case -4:
            trackingMode = .normal
        default:
            return
        }
    }
    
    func mapView(_ mapView: NMFMapView, cameraIsChangingByReason reason: Int) {
        guard let tooltipPoint = tooltip.getPoint(in: mapView) else { return }
        updateTooltipPoint(tooltipPoint)
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
        onMapViewCameraIdle.accept(())
    }
    
}

extension ORBMapView: NMFMapViewTouchDelegate {
    
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        self.hideTooltip()
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
