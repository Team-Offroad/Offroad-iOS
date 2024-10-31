//
//  QuestMapViewController.swift
//  Offroad-iOS
//
//  Created by 김민성 on 2024/07/07.
//

import CoreLocation
import UIKit

import NMapsMap
import RxSwift
import RxCocoa
import SnapKit
import Then

class QuestMapViewController: OffroadTabBarViewController {
    
    //MARK: - Properties
    
    private let viewModel = QuestMapViewModel()
    private let rootView = QuestMapView()
    
    private let locationManager = CLLocationManager()
    private let locationService = RegisteredPlaceService()
    
    private var disposeBag = DisposeBag()
    private var currentZoomLevel: Double = 14
    private var searchedPlaceArray: [RegisteredPlaceInfo] = []
    private var isFocused: Bool = false
    private var currentLocation: NMGLatLng = NMGLatLng(lat: 0, lng: 0)
    
    private var markerPoint: CGPoint? {
        guard let selectedMarker = viewModel.selectedMarker else { return nil }
        let selectedMarkerPosition = rootView.naverMapView.mapView.projection.point(from: selectedMarker.position)
        return self.rootView.naverMapView.mapView.convert(selectedMarkerPosition, to: self.rootView)
    }
    
    private var currentPositionTarget: NMGLatLng {
        rootView.naverMapView.mapView.cameraPosition.target
    }
    
    //MARK: - UI Properties
    
    var tooltipWindow: PlaceInfoTooltipWindow!
    
    //MARK: - Life Cycle
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        bindData()
        setupDelegates()
        rootView.naverMapView.mapView.positionMode = .direction
        locationManager.startUpdatingHeading()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
        guard let offroadTabBarController = tabBarController as? OffroadTabBarController else { return }
        offroadTabBarController.showTabBarAnimation()
        
        rootView.naverMapView.mapView.positionMode = .direction
        viewModel.isCompassMode = false
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        guard tooltipWindow == nil else { return }
        let naverMapViewFrame = self.rootView.naverMapView.frame
        let contentFrame = CGRect(
            origin: naverMapViewFrame.origin,
            size: .init(
                width: naverMapViewFrame.width,
                height: naverMapViewFrame.height - (view.safeAreaInsets.bottom + 107)
            )
        )
        tooltipWindow = PlaceInfoTooltipWindow(contentFrame: contentFrame)
        bindTooltip()
        tooltipWindow.makeKeyAndVisible()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.requestAuthorization()
        viewModel.updateRegisteredPlaces(at: currentPositionTarget)
        let orangeLocationOverlayImage = rootView.orangeLocationOverlayImage
        rootView.naverMapView.mapView.locationOverlay.icon = orangeLocationOverlayImage
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        self.tooltipWindow = nil
    }
    
}

extension QuestMapViewController {
    
    //MARK: - @objc Func
    
    @objc private func switchTrackingMode() {
        tooltipWindow.placeInfoViewController.hideTooltip()
        switch rootView.naverMapView.mapView.positionMode == .normal {
        case true:
            flyToMyPosition(completion: { [weak self] isCancelled in
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
            let orangeLocationOverlayImage = rootView.orangeLocationOverlayImage
            rootView.naverMapView.mapView.locationOverlay.icon = orangeLocationOverlayImage
        }
    }
    
    //MARK: - Private Func
    
    private func bindTooltip() {
        self.tooltipWindow.placeInfoViewController.shouldHideTooltip
            .debug()
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                self.tooltipWindow.placeInfoViewController.hideTooltip { [weak self] in
                    guard let self else { return }
                    self.viewModel.selectedMarker = nil
                }
            }).disposed(by: disposeBag)
        
        self.tooltipWindow.placeInfoViewController.rootView.tooltip.exploreButton.rx.tap.bind { [weak self] _ in
            guard let self else { return }
            self.viewModel.authenticatePlaceAdventure(placeInfo: viewModel.selectedMarker!.placeInfo)
            self.tooltipWindow.placeInfoViewController.hideTooltip(completion: { [weak self] in
                guard let self else { return }
                self.viewModel.selectedMarker = nil
            })
        }.disposed(by: disposeBag)
    }
    
    private func bindData() {
        viewModel.networkFailureSubject
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                self.showToast(message: "네트워크 연결 상태를 확인해주세요.", inset: 66)
            }).disposed(by: disposeBag)
        
        viewModel.shouldRequestLocationAuthorization
            .subscribe { _ in
                let alertController = ORBAlertController(
                    title: "위치 접근 권한이 막혀있습니다.",
                    message: "위치 정보 권한을 허용해 주세요", type: .normal
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
            viewModel.isLocationAdventureAuthenticated,
            viewModel.successCharacterImage,
            viewModel.completeQuestList
        )
        .observe(on: MainScheduler.instance)
        .subscribe(onNext: { [weak self] success, image, completeQuests in
            guard let self else { return }
            if success {
                self.viewModel.updateRegisteredPlaces(at: self.currentPositionTarget)
            }
            self.popupAdventureResult(isSuccess: success, image: image)
        }).disposed(by: disposeBag)
        
        rootView.reloadPlaceButton.rx.tap.bind { [weak self] _ in
            guard let self else { return }
            self.rootView.reloadPlaceButton.isEnabled = false
            try? self.viewModel.markersSubject.value().forEach({ marker in marker.mapView = nil })
            self.viewModel.updateRegisteredPlaces(at: self.currentPositionTarget)
        }.disposed(by: disposeBag)
        
        rootView.switchTrackingModeButton.rx.tap.bind { [weak self] _ in
            guard let self else { return }
            self.switchTrackingMode()
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
    
    private func setupDelegates() {
        rootView.naverMapView.mapView.addCameraDelegate(delegate: self)
        rootView.naverMapView.mapView.touchDelegate = self
        locationManager.delegate = self
    }
    
    private func focusToMarker(_ marker: NMFMarker) {
        currentZoomLevel = rootView.naverMapView.mapView.zoomLevel
        let markerLatLng = NMGLatLng(lat: marker.position.lat, lng: marker.position.lng)
        let cameraUpdate = NMFCameraUpdate(scrollTo: markerLatLng)
        cameraUpdate.animation = .easeOut
        cameraUpdate.reason = 20
        rootView.naverMapView.mapView.moveCamera(cameraUpdate)
    }
    
    private func flyToMyPosition(completion: ((Bool) -> Void)? = nil) {
        guard let currentCoord = locationManager.location?.coordinate else { return }
        let currentLatLng = NMGLatLng(lat: currentCoord.latitude, lng: currentCoord.longitude)
        let cameraUpdate = NMFCameraUpdate(scrollTo: currentLatLng)
        cameraUpdate.reason = 1
        cameraUpdate.animation = .easeOut
        rootView.naverMapView.mapView.moveCamera(cameraUpdate) { isCancelled in
            print("호출호출")
            completion?(isCancelled)
        }
    }
    
    private func markerTouchHandler(overlay: NMFOverlay) -> Bool {
        guard let marker = overlay as? OffroadNMFMarker else { return false }
        self.viewModel.selectedMarker = marker
        self.focusToMarker(marker)
        let orangeLocationOverlayImage = rootView.orangeLocationOverlayImage
        self.rootView.naverMapView.mapView.locationOverlay.icon = orangeLocationOverlayImage
        self.tooltipWindow.placeInfoViewController.rootView.tooltip.configure(with: marker.placeInfo)
        self.tooltipWindow.placeInfoViewController.rootView.tooltipAnchorPoint = markerPoint!
        self.tooltipWindow.placeInfoViewController.showToolTip()
        return true
    }
    
    private func popupAdventureResult(isSuccess: Bool, image: UIImage?) {
        let title: String = isSuccess ? "탐험 성공" : "탐험 실패"
        let message: String = isSuccess ? "탐험에 성공했어요!\n이곳에 무엇이 있는지 천천히 살펴볼까요?" : "탐험에 실패했어요.\n위치를 다시 한 번 확인해주세요."
        let buttonTitle: String = isSuccess ? "홈으로" : "확인"
        let alertController = ORBAlertController(title: title, message: message, type: .explorationResult)
        alertController.configureExplorationResultImage { $0.image = image }
        alertController.configureMessageLabel { $0.highlightText(targetText: "위치", font: .offroad(style: .iosTextBold)) }
        alertController.xButton.isHidden = true
        let okAction = ORBAlertAction(title: buttonTitle, style: .default) { [weak self] _ in
            guard let self else { return }
            if isSuccess { self.tabBarController?.selectedIndex = 0 }
        }
        alertController.addAction(okAction)
        present(alertController, animated: true)
    }
    
}

//MARK: - NMFMapViewCameraDelegate

extension QuestMapViewController: NMFMapViewCameraDelegate {
    
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
            if viewModel.selectedMarker != nil {
                tooltipWindow.placeInfoViewController.rootView.tooltipAnchorPoint = markerPoint!
                tooltipWindow.placeInfoViewController.hideTooltip { [weak self] in
                    guard let self else { return }
                    self.viewModel.selectedMarker = nil
                }
            }
        // 버튼 선택으로 카메라 이동
        case -2:
            viewModel.isCompassMode = false
            let orangeLocationOverlayImage = rootView.orangeLocationOverlayImage
            rootView.naverMapView.mapView.locationOverlay.icon = orangeLocationOverlayImage
            rootView.customizeLocationOverlaySubIcon(mode: .compass)
            
            guard viewModel.selectedMarker != nil else { return }
            tooltipWindow.placeInfoViewController.hideTooltip()
        default:
            return
        }
    }
    
    func mapView(_ mapView: NMFMapView, cameraIsChangingByReason reason: Int) {
        if viewModel.selectedMarker != nil {
            tooltipWindow.placeInfoViewController.rootView.tooltipAnchorPoint = markerPoint!
        }
    }
    
    func mapView(_ mapView: NMFMapView, cameraDidChangeByReason reason: Int, animated: Bool) {
        let orangeLocationOverlayImage = rootView.orangeLocationOverlayImage
        rootView.naverMapView.mapView.locationOverlay.icon = orangeLocationOverlayImage
        
        switch reason {
        // API 호출로 카메라 이동
        case 0:
            rootView.naverMapView.mapView.positionMode = .direction
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

extension QuestMapViewController: NMFMapViewTouchDelegate {
    
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        if viewModel.selectedMarker != nil {
            tooltipWindow.placeInfoViewController.rootView.tooltipAnchorPoint = markerPoint!
            tooltipWindow.placeInfoViewController.hideTooltip { [weak self] in
                guard let self else { return }
                self.viewModel.selectedMarker = nil
            }
        }
    }
    
}

//MARK: - CLLocationManagerDelegate

extension QuestMapViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        let currentHeading = newHeading.trueHeading
        
        rootView.naverMapView.mapView.locationOverlay.heading = currentHeading
        let orangeLocationOverlayImage = rootView.orangeLocationOverlayImage
        rootView.naverMapView.mapView.locationOverlay.icon = orangeLocationOverlayImage
        
        guard viewModel.isCompassMode else { return }
        let cameraUpdate = NMFCameraUpdate(heading: currentHeading)
        cameraUpdate.reason = 10
        cameraUpdate.animation = .easeOut
        rootView.naverMapView.mapView.moveCamera(cameraUpdate)
        rootView.naverMapView.mapView.locationOverlay.icon = orangeLocationOverlayImage
    }
    
}
