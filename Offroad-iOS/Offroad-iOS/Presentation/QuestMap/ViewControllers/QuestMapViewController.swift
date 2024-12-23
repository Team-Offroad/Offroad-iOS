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
    private let locationService = RegisteredPlaceService()
    
    private var disposeBag = DisposeBag()
    private var currentZoomLevel: Double = 14
    private var searchedPlaceArray: [RegisteredPlaceInfo] = []
    private var isFocused: Bool = false
    private var currentLocation: NMGLatLng = NMGLatLng(lat: 0, lng: 0)
    private var latestCategory: String?
    
    private var locationManager: CLLocationManager { viewModel.locationManager }
    
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
        
        if CLLocationManager.locationServicesEnabled() {
            viewModel.requestAuthorization()
        } else {
            viewModel.locationServiceDisabledRelay.accept(())
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
        tooltipWindow.isHidden = false
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        
        let orangeLocationOverlayImage = rootView.locationOverlayImage
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
            let orangeLocationOverlayImage = rootView.locationOverlayImage
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
            if CLLocationManager.locationServicesEnabled() {
                self.viewModel.authenticatePlaceAdventure(placeInfo: viewModel.selectedMarker!.placeInfo)
                self.tooltipWindow.placeInfoViewController.hideTooltip(completion: { [weak self] in
                    guard let self else { return }
                    self.viewModel.selectedMarker = nil
                })
            } else {
                viewModel.locationServiceDisabledRelay.accept(())
            }
        }.disposed(by: disposeBag)
    }
    
    private func bindData() {
        viewModel.startLoading.subscribe(onNext: {
            self.tabBarController?.view.startLoading()
        }).disposed(by: disposeBag)
        
        viewModel.stopLoading.subscribe(onNext: {
            self.tabBarController?.view.stopLoading()
        }).disposed(by: disposeBag)
        
        viewModel.networkFailureSubject
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                self.tabBarController?.view.stopLoading()
            }).disposed(by: disposeBag)
        
        viewModel.locationServiceDisabledRelay
            .observe(on: ConcurrentMainScheduler.instance)
            .subscribe { [weak self] _ in
                guard let self else { return }
                self.showToast(message: "위치 기능이 비활성화되었습니다.\n탐험을 인증하기 위해서는 위치 기능을 활성화해 주세요.", inset: 66)
            }.disposed(by: disposeBag)
        
        viewModel.shouldRequestLocationAuthorization
            .observe(on: ConcurrentMainScheduler.instance)
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
            self.tabBarController?.view.stopLoading()
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
        }.disposed(by: disposeBag)
        
        rootView.switchTrackingModeButton.rx.tap.bind { [weak self] _ in
            guard let self else { return }
            switch self.viewModel.locationManager.authorizationStatus {
            case .authorizedAlways, .authorizedWhenInUse:
                self.switchTrackingMode()
            default:
                self.viewModel.requestAuthorization()
                return
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
        viewModel.isCompassMode = false
        viewModel.selectedMarker = marker
        focusToMarker(marker)
        rootView.naverMapView.mapView.locationOverlay.icon = rootView.locationOverlayImage
        latestCategory = marker.placeInfo.placeCategory
        tooltipWindow.placeInfoViewController.rootView.tooltip.configure(with: marker.placeInfo)
        tooltipWindow.placeInfoViewController.rootView.tooltipAnchorPoint = markerPoint!
        tooltipWindow.placeInfoViewController.showToolTip()
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
            let orangeLocationOverlayImage = rootView.locationOverlayImage
            rootView.naverMapView.mapView.locationOverlay.icon = orangeLocationOverlayImage
            rootView.customizeLocationOverlaySubIcon(mode: .compass)
            
            guard viewModel.selectedMarker != nil else { return }
            tooltipWindow.placeInfoViewController.hideTooltip() { [weak self] in
                guard let self else { return }
                self.viewModel.selectedMarker = nil
            }
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
        let orangeLocationOverlayImage = rootView.locationOverlayImage
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
        let orangeLocationOverlayImage = rootView.locationOverlayImage
        rootView.naverMapView.mapView.locationOverlay.icon = orangeLocationOverlayImage
        
        guard viewModel.isCompassMode else { return }
        let cameraUpdate = NMFCameraUpdate(heading: currentHeading)
        cameraUpdate.reason = 10
        cameraUpdate.animation = .easeOut
        rootView.naverMapView.mapView.moveCamera(cameraUpdate)
        rootView.naverMapView.mapView.locationOverlay.icon = orangeLocationOverlayImage
    }
    
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        switch manager.authorizationStatus {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            
            // 가족 공유 등의 기능에서 부모 혹은 보호자가 앱을 사용할 수 없도록 제한했을 때
        case .restricted:
            viewModel.shouldRequestLocationAuthorization.accept(())
            
            /*
             - 사용자가 앱에 위치 사용 권한을 허용하지 않은 경우
             - 위치 서비스를 끈 경우
             - 비행기 모드로 인해 위치 서비스 사용이 불가한 경우
             */
        case .denied:
            if CLLocationManager.locationServicesEnabled() {
                viewModel.shouldRequestLocationAuthorization.accept(())
            } else {
                viewModel.locationServiceDisabledRelay.accept(())
            }
        case .authorizedAlways, .authorizedWhenInUse:
            flyToMyPosition()
            rootView.naverMapView.mapView.positionMode = .direction
        @unknown default:
            return
        }
    }
    
}
