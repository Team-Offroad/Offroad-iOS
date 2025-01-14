//
//  ORBMapViewController.swift
//  Offroad-iOS
//
//  Created by 김민성 on 12/26/24.
//

import CoreLocation
import UIKit

import NMapsMap
import RxSwift
import RxCocoa
import SnapKit
import Then

class ORBMapViewController: OffroadTabBarViewController {
    
    //MARK: - Properties
    
    private let viewModel = ORBMapViewModel()
    private let rootView = ORBMapView()
    private let locationService = RegisteredPlaceService()
    
    private var disposeBag = DisposeBag()
    private var searchedPlaceArray: [RegisteredPlaceInfo] = []
    private var isFocused: Bool = false
    private var currentLocation: NMGLatLng = NMGLatLng(lat: 0, lng: 0)
    private var latestCategory: String?
    
    private var locationManager: CLLocationManager { viewModel.locationManager }
    private var selectedMarker: ORBNMFMarker? = nil
    private var markerPoint: CGPoint? {
        guard let selectedMarker else { return nil }
        let selectedMarkerPosition = rootView.naverMapView.mapView.projection.point(from: selectedMarker.position)
        return self.rootView.naverMapView.mapView.convert(selectedMarkerPosition, to: self.rootView)
    }
    
    private var currentPositionTarget: NMGLatLng {
        rootView.naverMapView.mapView.cameraPosition.target
    }
    
    var isTooltipShown: Bool = false
    private let shadingAnimator = UIViewPropertyAnimator(duration: 0.3, dampingRatio: 1)
    private let tooltipTransparencyAnimator = UIViewPropertyAnimator(duration: 0.2, dampingRatio: 1)
    private let tooltipShowingAnimator = UIViewPropertyAnimator(duration: 0.4, dampingRatio: 0.8)
    private let tooltipHidingAnimator = UIViewPropertyAnimator(duration: 0.25, dampingRatio: 1)
    
    //MARK: - Life Cycle
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindData()
        setupTooltipAction()
        setupDelegates()
        setupGestureRecognizers()
        rootView.naverMapView.mapView.positionMode = .direction
        locationManager.startUpdatingHeading()
        viewModel.checkLocationAuthorizationStatus { [weak self] authorizationCase in
            guard let self else { return }
            if authorizationCase != .fullAccuracy && authorizationCase != .reducedAccuracy {
                // 사용자 위치 불러올 수 없을 시 초기 위치 설정
                // 초기 위치: 서울시 동대문구 망우로 46 DDM청년창업센터
                self.moveCamera(scrollTo: .init(lat: 37.5887592, lng: 127.0585367), animationDuration: 0)
            }
        }
        viewModel.updateRegisteredPlaces(at: currentPositionTarget)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
        guard let offroadTabBarController = tabBarController as? OffroadTabBarController else { return }
        offroadTabBarController.showTabBarAnimation()
        
        viewModel.isCompassMode = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        let orangeLocationOverlayImage = rootView.locationOverlayImage
        rootView.naverMapView.mapView.locationOverlay.icon = orangeLocationOverlayImage
    }
    
}

extension ORBMapViewController {
    
    //MARK: - Private Func
    
    private func switchTrackingMode() {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            switch rootView.naverMapView.mapView.positionMode == .normal {
            case true:
                focusToMyPosition(completion: { [weak self] isCancelled in
                    guard let self else { return }
                    guard !isCancelled else { return }
                    self.rootView.naverMapView.mapView.positionMode = .direction
                })
            case false:
                viewModel.isCompassMode.toggle()
                let currentHeading = locationManager.heading?.trueHeading ?? 0
                rootView.naverMapView.mapView.locationOverlay.heading = currentHeading
                guard viewModel.isCompassMode else {
                    rootView.naverMapView.mapView.positionMode = .direction
                    return
                }
                let cameraUpdate = NMFCameraUpdate(heading: currentHeading)
                cameraUpdate.reason = 10
                cameraUpdate.animation = .easeOut
                rootView.naverMapView.mapView.moveCamera(cameraUpdate)
                let orangeLocationOverlayImage = rootView.locationOverlayImage
                rootView.naverMapView.mapView.locationOverlay.icon = orangeLocationOverlayImage
            }
        }
    }
    
    private func bindData() {
        viewModel.startLoading
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [weak self] in
            guard let self else { return }
            self.view.startLoading()
        }).disposed(by: disposeBag)
        
        viewModel.stopLoading
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [weak self] in
                guard let self else { return }
                self.view.stopLoading()
            }).disposed(by: disposeBag)
        
        viewModel.networkFailureSubject
            .asDriver(onErrorJustReturn: ())
            .drive(onNext: { [weak self] in
                guard let self else { return }
                self.view.stopLoading()
            }).disposed(by: disposeBag)
        
        viewModel.locationServicesDisabledRelay
            .observe(on: ConcurrentMainScheduler.instance)
            .subscribe { [weak self] _ in
                guard let self else { return }
                self.showToast(message: AlertMessage.locationServicesDisabledMessage, inset: 66)
            }.disposed(by: disposeBag)
        
        viewModel.locationUnauthorizedMessage
            .asDriver(onErrorJustReturn: "")
            .drive { [weak self] message in
                guard let self else { return }
                self.viewModel.isCompassMode = false
                let alertController = ORBAlertController(
                    title: AlertMessage.locationUnauthorizedTitle,
                    message: message, type: .normal
                )
                let okAction = ORBAlertAction(title: "확인", style: .default) { _ in return }
                alertController.addAction(okAction)
                self.present(alertController, animated: true)
            }.disposed(by: disposeBag)
        
        viewModel.markersSubject
            .flatMap { Observable.from($0) }
            .subscribe(onNext: { [weak self] marker in
                guard let self else { return }
                marker.touchHandler = { [weak self] overlay in
                    guard let self else { return false }
                    return self.markerTouchHandler(overlay: overlay)
                }
                marker.mapView = self.rootView.naverMapView.mapView
            }).disposed(by: disposeBag)
        
        Observable.zip(
            viewModel.isLocationAuthorized,
            viewModel.successCharacterImage,
            viewModel.completeQuestList,
            viewModel.isFirstVisitToday
        )
        .observe(on: MainScheduler.instance)
        .subscribe(onNext: { [weak self] locationValidation, image, completeQuests, isFirstVisitToday in
            guard let self else { return }
            if locationValidation {
                self.viewModel.updateRegisteredPlaces(at: self.currentPositionTarget)
                MyInfoManager.shared.shouldUpdateCharacterAnimation.accept(latestCategory ?? "NONE")
                MyInfoManager.shared.didSuccessAdventure.accept(())
            }
            self.view.stopLoading()
            self.popupAdventureResult(isValidLocation: locationValidation,
                                      image: image,
                                      completeQuests: completeQuests,
                                      isFirstVisitToday: isFirstVisitToday)
        }).disposed(by: disposeBag)
        
        rootView.reloadPlaceButton.rx.tap.bind { [weak self] _ in
            guard let self else { return }
            self.rootView.reloadPlaceButton.isEnabled = false
            try? self.viewModel.markersSubject.value().forEach({ marker in marker.mapView = nil })
            self.viewModel.updateRegisteredPlaces(at: self.currentPositionTarget)
            self.hideTooltip()
        }.disposed(by: disposeBag)
        
        rootView.switchTrackingModeButton.rx.tap.bind { [weak self] _ in
            guard let self else { return }
            
            self.viewModel.checkLocationAuthorizationStatus { [weak self] authorizationCase in
                guard let self else { return }
                switch authorizationCase {
                case .notDetermined:
                    return
                case .fullAccuracy:
                    self.switchTrackingMode()
                case .reducedAccuracy:
                    self.switchTrackingMode()
                case .denied, .restricted:
                    self.viewModel.locationUnauthorizedMessage.accept(AlertMessage.locationUnauthorizedMessage)
                case .servicesDisabled:
                    self.viewModel.locationServicesDisabledRelay.accept(())
                }
            }
        }.disposed(by: disposeBag)
        
        rootView.questListButton.rx.tap.bind { [weak self] _ in
            guard let self else { return }
            self.navigationController?.pushViewController(QuestListViewController(), animated: true)
        }.disposed(by: disposeBag)
        
        rootView.placeListButton.rx.tap.bind {  [weak self] _ in
            guard let self else { return }
            self.navigationController?.pushViewController(PlaceListViewController(), animated: true)
        }.disposed(by: disposeBag)
    }
    
    private func setupTooltipAction() {
        rootView.tooltip.exploreButton.rx.tap.bind(onNext: { [weak self] _ in
            guard let self else { return }
            
            self.viewModel.checkLocationAuthorizationStatus { [weak self] authorizationCase in
                guard let self else { return }
                switch authorizationCase {
                case .notDetermined:
                    return
                case .fullAccuracy:
                    self.viewModel.authenticatePlaceAdventure(placeInfo: selectedMarker!.placeInfo)
                case .reducedAccuracy:
                    self.viewModel.locationUnauthorizedMessage.accept(AlertMessage.locationReducedAccuracyMessage)
                case .denied, .restricted:
                    self.viewModel.locationUnauthorizedMessage.accept(AlertMessage.locationUnauthorizedAdventureMessage)
                case .servicesDisabled:
                    self.viewModel.locationServicesDisabledRelay.accept(())
                }
            }
        }).disposed(by: disposeBag)
        
        rootView.tooltip.closeButton.rx.tap.bind(onNext: { [weak self] in
            guard let self else { return }
            self.hideTooltip()
        }).disposed(by: disposeBag)
    }
    
    private func setupDelegates() {
        rootView.naverMapView.mapView.addCameraDelegate(delegate: self)
        rootView.naverMapView.mapView.touchDelegate = self
        locationManager.delegate = self
    }
    
    private func setupGestureRecognizers() {
        let tapGestureRecognizer = UITapGestureRecognizer()
        tapGestureRecognizer.rx.event.subscribe(onNext: { [weak self] gesture in
            guard let self else { return }
            self.hideTooltip()
        }).disposed(by: disposeBag)
        rootView.shadingView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    private func focusToMarker(_ marker: NMFMarker) {
        let markerLatLng = NMGLatLng(lat: marker.position.lat, lng: marker.position.lng)
        moveCamera(scrollTo: markerLatLng, reason: 20)
    }
    
    private func focusToMyPosition(completion: ((Bool) -> Void)? = nil) {
        guard let currentCoord = locationManager.location?.coordinate else { return }
        let currentLatLng = NMGLatLng(lat: currentCoord.latitude, lng: currentCoord.longitude)
        moveCamera(scrollTo: currentLatLng, reason: 1) { isCancelled in
            completion?(isCancelled)
        }
    }
    
    /// 지도의 카메라를 지정된 좌표(`NMGLatLng`)로 이동시키는 함수
    /// - Parameters:
    ///   - coordinate: 이동하고자 하는 좌표값. `NMGLatLng` 타입
    ///   - animationDuration: 애니메이션 시간. 0으로 설정할 경우, 애니메이션 없이 바로 이동. 기본값은 NAVER Map iOS SDK에서 설정하는 0.2
    ///   - reason: 카메라 이동에 사용될 `NMFCameraUpdate` 타입의 `reason` 속성에 할당할 값. 기본값은 `NMFMapChangedByDeveloper`이며, -1에 해당. (개발자가 API를 호출해 카메라가 움직였음을 의미)
    ///   - completion: 카메라 이동이 완료되었을 때 호출되는 콜백 블록. 애니메이션이 있으면 완전히 끝난 후에 호출됩니다. `Bool` 타입의 매개변수는 카메라 이동이 완료되기 전에 다른 카메라 이동이 호출되거나 사용자가 제스처로 지도를 조작한 경우 `true`입니다.
    private func moveCamera(
        scrollTo coordinate: NMGLatLng,
        // NAVER Map iOS SDK에서 지정하는 기본값이 0.2
        animationDuration: TimeInterval = 0.2,
        reason: Int32 = Int32(NMFMapChangedByDeveloper),
        completion: ((Bool) -> Void)? = nil
    ) {
        let cameraUpdate = NMFCameraUpdate(scrollTo: coordinate)
        cameraUpdate.reason = reason
        cameraUpdate.animation = .easeOut
        cameraUpdate.animationDuration = animationDuration
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.rootView.naverMapView.mapView.moveCamera(cameraUpdate) { isCancelled in
                completion?(isCancelled)
            }
        }
    }
    
    /// 지도의 카메라를 현재 위치에서 `delta` 포인트만큼 이동시키는 함수
    /// - Parameters:
    ///   - delta: 이동할 거리. 가로, 세로로 `pt` 단위이며 각각의 값을 `x`, `y` 속성으로 갖는 `CGPoint` 값.
    ///   - animationDuration: 애니메이션 시간. 0으로 설정할 경우, 애니메이션 없이 바로 이동. 기본값은 NAVER Map iOS SDK에서 설정하는 0.2
    ///   - reason: 카메라 이동에 사용될 `NMFCameraUpdate` 타입의 `reason` 속성에 할당할 값. 기본값은 `NMFMapChangedByDeveloper`이며, -1에 해당. (개발자가 API를 호출해 카메라가 움직였음을 의미)
    ///   - completion: 카메라 이동이 완료되었을 때 호출되는 콜백 블록. 애니메이션이 있으면 완전히 끝난 후에 호출됩니다. `Bool` 타입의 매개변수는 카메라 이동이 완료되기 전에 다른 카메라 이동이 호출되거나 사용자가 제스처로 지도를 조작한 경우 `true`입니다.
    private func moveCamera(
        scrollBy delta: CGPoint,
        // NAVER Map iOS SDK에서 지정하는 기본값이 0.2
        animationDuration: TimeInterval = 0.2,
        reason: Int32 = Int32(NMFMapChangedByDeveloper),
        completion: ((Bool) -> Void)? = nil
    ) {
        let cameraUpdate = NMFCameraUpdate(scrollBy: delta)
        cameraUpdate.reason = reason
        cameraUpdate.animation = .easeOut
        cameraUpdate.animationDuration = animationDuration
        rootView.naverMapView.mapView.moveCamera(cameraUpdate) { isCancelled in
            completion?(isCancelled)
        }
    }
    
    /// 마커를 탭 시 동작할 함수
    ///- Parameters overlay: 탭 이벤트를 받아서 전달하는 NMFOverlay
    /// - Returns: `true`를 반환할 경우 마커를 탭 시 메서드를 실행. 그렇지 않을 경우 `NMFMapView`까지 이벤트가 전달되어 `NMFMapViewTouchDelegate`의 `mapView(_:didTapMap:point:)`가  호출됩니다.
    private func markerTouchHandler(overlay: NMFOverlay) -> Bool {
        guard !isTooltipShown else { return false }
        guard let marker = overlay as? ORBNMFMarker else { return false }
        let projection = rootView.naverMapView.mapView.projection
        let point = projection.point(from: marker.position)
        guard !rootView.markerTapBlocker.frame.contains(point) else { return false }
        viewModel.isCompassMode = false
        selectedMarker = marker
        rootView.naverMapView.mapView.locationOverlay.icon = rootView.locationOverlayImage
        latestCategory = marker.placeInfo.placeCategory
        
        // 툴팁 보이기
        rootView.tooltip.configure(with: marker.placeInfo)
        rootView.tooltipAnchorPoint = markerPoint!
        showTooltip()
        
        let mapFrame = rootView.naverMapView.mapView.frame
        let delta = viewModel.caculateDeltaToShowTooltip(point: point,
                                            at: mapFrame,
                                            tooltipSize: rootView.tooltip.frame.size,
                                            contentInset: 20)
        moveCamera(scrollBy: delta, animationDuration: 0.3)
        return true
    }
    
    private func popupAdventureResult(
        isValidLocation: Bool,
        image: UIImage?,
        completeQuests: [CompleteQuest]?,
        isFirstVisitToday: Bool
    ) {
        let title: String = (isValidLocation && isFirstVisitToday) ? AlertMessage.adventureSuccessTitle : AlertMessage.adventureFailureTitle
        let message: String
        let buttonTitle: String
        
        // 탐험 성공
        if isValidLocation && isFirstVisitToday {
            message = AlertMessage.adventureSuccessMessage
            buttonTitle = "홈으로"
            
        // 위치는 맞으나, 해당 날짜에 두 번째 방문인 경우
        } else if isValidLocation && !isFirstVisitToday {
            message = AlertMessage.adventureFailureVisitCountMessage
            buttonTitle = "확인"
            
        // isValidLocation이 false인 경우 (잘못된 위치)
        } else {
            message = AlertMessage.adventureFailureLocationMessage
            buttonTitle = "확인"
        }
        
        let alertController = ORBAlertController(title: title, message: message, type: .explorationResult)
        alertController.configureExplorationResultImage { $0.image = image }
        alertController.configureMessageLabel {
            $0.highlightText(targetText: "위치", font: .offroad(style: .iosTextBold))
            $0.highlightText(targetText: "한 번", font: .offroad(style: .iosTextBold))
            $0.highlightText(targetText: "내일 다시", font: .offroad(style: .iosTextBold))
        }
        alertController.xButton.isHidden = true
        let okAction = ORBAlertAction(title: buttonTitle, style: .default) { [weak self] _ in
            guard let self else { return }
            if isValidLocation && isFirstVisitToday {
                self.tabBarController?.selectedIndex = 0
            }
            
            guard let completeQuests, isValidLocation else { return }
            let message: String
            if completeQuests.count <= 0 {
                return
            } else if completeQuests.count == 1 {
                message = "퀘스트 '\(completeQuests.first!.name)'을(를) 클리어했어요! 마이페이지에서 보상을 확인해보세요."
            } else { //if completeQuests.count > 1
                message = "퀘스트 '\(completeQuests.first!.name)' 외 \(completeQuests.count-1)개를 클리어했어요! 마이페이지에서 보상을 확인해보세요."
            }
            let questCompleteAlertController = ORBAlertController(title: "퀘스트 성공 !", message: message, type: .normal)
            questCompleteAlertController.xButton.isHidden = true
            let action = ORBAlertAction(title: "확인", style: .default) { _ in return }
            questCompleteAlertController.addAction(action)
            present(questCompleteAlertController, animated: true)
        }
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    
    private func showTooltip(completion: (() -> Void)? = nil) {
        rootView.tooltip.transform = CGAffineTransform(scaleX: 0.1, y: 0.1)
        rootView.tooltip.alpha = 0
        rootView.layoutIfNeeded()
        tooltipHidingAnimator.stopAnimation(true)
        
        shadingAnimator.addAnimations { [weak self] in
            guard let self else { return }
            self.rootView.shadingView.backgroundColor = .blackOpacity(.black25)
        }
        tooltipTransparencyAnimator.addAnimations { [weak self] in
            guard let self else { return }
            self.rootView.tooltip.alpha = 1
        }
        tooltipShowingAnimator.addAnimations { [weak self] in
            guard let self else { return }
            self.rootView.tooltip.transform = .identity
            self.rootView.layoutIfNeeded()
        }
        tooltipShowingAnimator.addCompletion { _ in
            completion?()
        }
        isTooltipShown = true
        rootView.compass.isHidden = true
        rootView.shadingView.isUserInteractionEnabled = true
        tooltipTransparencyAnimator.startAnimation()
        shadingAnimator.startAnimation()
        tooltipShowingAnimator.startAnimation()
    }
    
    private func hideTooltip(completion: (() -> Void)? = nil) {
        guard isTooltipShown else { return }
        tooltipShowingAnimator.stopAnimation(true)
        
        shadingAnimator.addAnimations { [weak self] in
            guard let self else { return }
            self.rootView.shadingView.backgroundColor = .clear
        }
        tooltipHidingAnimator.addAnimations { [weak self] in
            guard let self else { return }
            self.rootView.tooltip.transform = CGAffineTransform(scaleX: 0.05, y: 0.05)
        }
        tooltipHidingAnimator.addAnimations({ [weak self] in
            guard let self else { return }
            self.rootView.tooltip.alpha = 0
        }, delayFactor: 0.3)
        tooltipHidingAnimator.addCompletion { [weak self] _ in
            guard let self else { return }
            self.rootView.tooltip.configure(with: nil)
            self.selectedMarker = nil
            self.rootView.shadingView.isUserInteractionEnabled = false
            completion?()
        }
        isTooltipShown = false
        rootView.compass.isHidden = false
        shadingAnimator.startAnimation()
        tooltipHidingAnimator.startAnimation()
    }
    
    private func setLocationOverlayHiddenState(to isHidden: Bool) {
        DispatchQueue.main.async { [weak self] in
            guard let self else { return }
            self.rootView.naverMapView.mapView.locationOverlay.hidden = isHidden
        }
    }
    
}

//MARK: - NMFMapViewCameraDelegate

extension ORBMapViewController: NMFMapViewCameraDelegate {
    
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
            viewModel.isCompassMode = false
        // 제스처 사용으로 카메라 이동
        case -1:
            viewModel.isCompassMode = false
            if selectedMarker != nil {
                // 툴팁 동기화 + 툴팁 숨기기
                rootView.tooltipAnchorPoint = markerPoint!
            }
        // 버튼 선택으로 카메라 이동
        case -2:
            viewModel.isCompassMode = false
            let orangeLocationOverlayImage = rootView.locationOverlayImage
            rootView.naverMapView.mapView.locationOverlay.icon = orangeLocationOverlayImage
            rootView.customizeLocationOverlaySubIcon(mode: .compass)
            
            guard selectedMarker != nil else { return }
            // 툴팁 숨기기
            hideTooltip()
        default:
            return
        }
    }
    
    func mapView(_ mapView: NMFMapView, cameraIsChangingByReason reason: Int) {
        if selectedMarker != nil {
            // 툴팁의 위치를 마커의 위치와 동기화
            rootView.tooltipAnchorPoint = markerPoint!
        }
    }
    
    func mapView(_ mapView: NMFMapView, cameraDidChangeByReason reason: Int, animated: Bool) {
        let orangeLocationOverlayImage = rootView.locationOverlayImage
        rootView.naverMapView.mapView.locationOverlay.icon = orangeLocationOverlayImage
        
        switch reason {
        // API 호출로 카메라 이동
        case 0:
            return
        // 핸드폰을 돌려서, 혹은 현재 위치 버튼 선택 후 위치 트래킹 활성화로 인해 카메라 방향이 회전한 경우
        case 10:
            rootView.naverMapView.mapView.positionMode = .direction
        default:
            return
        }
    }
    
    func mapViewCameraIdle(_ mapView: NMFMapView) {
        rootView.reloadPlaceButton.isEnabled = true
    }
    
}

//MARK: - NMFMapViewTouchDelegate

extension ORBMapViewController: NMFMapViewTouchDelegate {
    
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        if selectedMarker != nil {
            // 툴팁 숨김처리
            hideTooltip()
        }
    }
    
}

//MARK: - CLLocationManagerDelegate

extension ORBMapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        let currentHeading = newHeading.trueHeading
        
        rootView.naverMapView.mapView.locationOverlay.heading = currentHeading
        let purpleLocationOverlayImage = rootView.locationOverlayImage
        rootView.naverMapView.mapView.locationOverlay.icon = purpleLocationOverlayImage
        
        guard viewModel.isCompassMode else { return }
        let cameraUpdate = NMFCameraUpdate(heading: currentHeading)
        cameraUpdate.reason = 10
        cameraUpdate.animation = .easeOut
        rootView.naverMapView.mapView.moveCamera(cameraUpdate)
        rootView.naverMapView.mapView.locationOverlay.icon = purpleLocationOverlayImage
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        viewModel.checkLocationAuthorizationStatus { authorizationCase in
            switch authorizationCase {
            case .notDetermined, .reducedAccuracy:
                return
            case .fullAccuracy:
                DispatchQueue.main.async { [weak self] in
                    guard let self else { return }
                    self.hideTooltip()
                    self.focusToMyPosition()
                    self.rootView.naverMapView.mapView.positionMode = .direction
                    self.setLocationOverlayHiddenState(to: false)
                }
            case .denied, .restricted:
                self.showToast(message: AlertMessage.locationUnauthorizedAdventureMessage, inset: 66)
                self.setLocationOverlayHiddenState(to: true)
            case .servicesDisabled:
                self.viewModel.locationServicesDisabledRelay.accept(())
                self.setLocationOverlayHiddenState(to: true)
            }
        }
    }
    
}

