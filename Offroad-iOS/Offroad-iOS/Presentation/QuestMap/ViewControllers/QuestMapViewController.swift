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
    private var currentZoomLevel: Double = 14
    private var searchedPlaceArray: [RegisteredPlaceInfo] = []
    private var selectedMarker: NMFMarker? = nil
    private var isFocused: Bool = false
    private var currentLocation: NMGLatLng = NMGLatLng(lat: 0, lng: 0)
//    private var shownMarkersArray: [NMFMarker] = [] {
//        didSet {
//            oldValue.forEach { $0.mapView = nil }
//            showMarkersOnMap()
//        }
//    }
    
    private var disposeBag = DisposeBag()
    
    private var selectedMarkerPosition: CGPoint? {
        guard let selectedMarker else { return nil }
        return rootView.naverMapView.mapView.projection.point(from: selectedMarker.position)
    }
    private var convertedSelectedMarkerPosition: CGPoint? {
        guard let selectedMarker else { return nil }
        return self.rootView.naverMapView.mapView.convert(selectedMarkerPosition!, to: self.rootView)
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
//        setupButtonsAction()
        setupDelegates()
        rootView.naverMapView.mapView.positionMode = .direction
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
        guard let offroadTabBarController = tabBarController as? OffroadTabBarController else { return }
        offroadTabBarController.showTabBarAnimation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        viewModel.requestAuthorization()
        viewModel.updateRegisteredPlaces(at: currentPositionTarget)
        rootView.naverMapView.mapView.positionMode = .disabled
        let orangeLocationOverlayImage = rootView.orangeLocationOverlayImage
        rootView.naverMapView.mapView.locationOverlay.icon = orangeLocationOverlayImage
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
        bindTooltipButtons()
        tooltipWindow.makeKeyAndVisible()
    }
    
}

extension QuestMapViewController {
    
    //MARK: - @objc
    
//    @objc private func reloadPlaceButtonTapped() {
//        updateCurrentLocation()
//        viewModel.updateRegisteredPlaces(at: currentPositionTarget)
//        showMarkersOnMap()
//    }
    
    @objc private func switchTrackingMode() {
        
        if selectedMarker != nil {
            tooltipWindow.placeInfoViewController.rootView.tooltipAnchorPoint = convertedSelectedMarkerPosition!
            tooltipWindow.placeInfoViewController.rootView.hideTooltip { [weak self] in
                guard let self else { return }
                self.tooltipWindow = nil
            }
        }
        
        if rootView.naverMapView.mapView.positionMode == .normal {
            flyToMyPosition { [weak self] in
                self?.rootView.naverMapView.mapView.positionMode = .compass
            }
            rootView.customizeLocationOverlaySubIcon(state: .compass)
        } else {
            rootView.naverMapView.mapView.positionMode = .normal
            let orangeLocationOverlayImage = rootView.orangeLocationOverlayImage
            rootView.naverMapView.mapView.locationOverlay.icon = orangeLocationOverlayImage
            rootView.naverMapView.mapView.locationOverlay.subIcon = nil
        }
        
    }
    
//    @objc private func pushQuestListViewController() {
//        print(#function)
//        navigationController?.pushViewController(QuestListViewController(), animated: true)
//    }
    
//    @objc private func pushPlaceListViewController() {
//        print(#function)
//        navigationController?.pushViewController(PlaceListViewController(), animated: true)
//    }
    
    //MARK: - Private Func
    
    private func bindTooltipButtons() {
        self.tooltipWindow.placeInfoViewController.shouldHideTooltip
            .debug()
            .subscribe(onNext: { [weak self] in
                guard let self else { return }
                self.tooltipWindow.placeInfoViewController.rootView.hideTooltip {
                    self.tooltipWindow.isTooltipShown = false
                    self.selectedMarker = nil
                }
            }).disposed(by: disposeBag)
    }
    
    private func bindData() {
        
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
                marker.touchHandler = { [weak self] _ in
                    guard let self else { return false }
//                    let marker = markerOverlay as! OffroadNMFMarker
                    
                    self.selectedMarker = marker
                    self.focusToMarker(marker)
                    self.tooltipWindow.placeInfoViewController.rootView.tooltip.configure(with: marker.placeInfo)
                    self.tooltipWindow.placeInfoViewController.rootView.tooltipAnchorPoint = convertedSelectedMarkerPosition!
                    self.tooltipWindow.placeInfoViewController.rootView.showToolTip()
                    return true
                }
                marker.mapView = self.rootView.naverMapView.mapView
            }).disposed(by: disposeBag)
        
        rootView.reloadPlaceButton.rx.tap.bind { [weak self] _ in
            guard let self else { return }
//            self.viewModel.updateCurrentLocation()
            self.viewModel.updateRegisteredPlaces(at: self.currentPositionTarget)
//            self.showMarkersOnMap()
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
    
//    private func setupButtonsAction() {
//        rootView.reloadPlaceButton
//            .addTarget(self, action: #selector(reloadPlaceButtonTapped), for: .touchUpInside)
//        rootView.switchTrackingModeButton
//            .addTarget(self, action: #selector(switchTrackingMode), for: .touchUpInside)
//        rootView.questListButton
//            .addTarget(self, action: #selector(pushQuestListViewController), for: .touchUpInside)
//        rootView.placeListButton
//            .addTarget(self, action: #selector(pushPlaceListViewController), for: .touchUpInside)
//    }
    
//    private func updateCurrentLocation() {
//        guard let currentCoordinate = locationManager.location?.coordinate else {
//            // 위치 정보 가져올 수 없음.
//            return
//        }
//        currentLocation = NMGLatLng(
//            lat: currentCoordinate.latitude,
//            lng: currentCoordinate.longitude
//        )
//        print("latitude: \(currentCoordinate.latitude)")
//        print("longitude: \(currentCoordinate.longitude)")
//    }
    
    private func setupDelegates() {
        rootView.naverMapView.mapView.addCameraDelegate(delegate: self)
    }
    
//    private func showMarkersOnMap() {
//        shownMarkersArray.forEach { marker in
//            marker.mapView = rootView.naverMapView.mapView
//        }
//    }
    
    private func focusToMarker(_ marker: NMFMarker) {
        currentZoomLevel = rootView.naverMapView.mapView.zoomLevel
        let markerLatLng = NMGLatLng(lat: marker.position.lat, lng: marker.position.lng)
        let cameraUpdate = NMFCameraUpdate(scrollTo: markerLatLng)
        cameraUpdate.animation = .easeOut
        rootView.naverMapView.mapView.moveCamera(cameraUpdate)
    }
    
    
    
//    private func showAlert(title: String, message: String) {
//        print(#function)
//        DispatchQueue.main.async { [weak self] in
//            let alertCon = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
//            let okAction = UIAlertAction(title: "넵!", style: .default)
//            alertCon.addAction(okAction)
//            
//            self?.present(alertCon, animated: true)
//        }
//    }
    
    private func flyToMyPosition(completion: @escaping () -> Void) {
        guard let currentCoord = locationManager.location?.coordinate else { return }
        let currentLatLng = NMGLatLng(lat: currentCoord.latitude, lng: currentCoord.longitude)
        let cameraUpdate = NMFCameraUpdate(scrollTo: currentLatLng)
        cameraUpdate.animation = .easeOut
        rootView.naverMapView.mapView.moveCamera(cameraUpdate) { isCancelled in
            completion()
        }
    }
    
    
    
}

//MARK: - NMFMapViewCameraDelegate

extension QuestMapViewController: NMFMapViewCameraDelegate {
    
    func mapView(_ mapView: NMFMapView, cameraWillChangeByReason reason: Int, animated: Bool) {
        print(#function)
        if reason == -2 {
            let orangeLocationOverlayImage = rootView.orangeLocationOverlayImage
            rootView.naverMapView.mapView.locationOverlay.icon = orangeLocationOverlayImage
            rootView.naverMapView.mapView.locationOverlay.subIcon = nil
        }
    }
    
    func mapView(_ mapView: NMFMapView, cameraIsChangingByReason reason: Int) {
        print(#function)
        if selectedMarker != nil {
            tooltipWindow.placeInfoViewController.rootView.tooltipAnchorPoint = convertedSelectedMarkerPosition!
//            tooltipWindow.placeInfoViewController.rootView.hideTooltip { [weak self] in
//                guard let self else { return }
//                self.tooltipWindow = nil
//            }
        }
    }
    
    func mapView(_ mapView: NMFMapView, cameraDidChangeByReason reason: Int, animated: Bool) {
        print(#function)
        let orangeLocationOverlayImage = rootView.orangeLocationOverlayImage
        rootView.naverMapView.mapView.locationOverlay.icon = orangeLocationOverlayImage
        if reason == -1 {
            rootView.naverMapView.mapView.locationOverlay.subIcon = nil
        }
        
        if selectedMarker != nil {
            tooltipWindow.placeInfoViewController.rootView.tooltipAnchorPoint = convertedSelectedMarkerPosition!
            // 사용자 제스처로 움직였을 시
            guard reason == -1 else { return }
            tooltipWindow.placeInfoViewController.rootView.hideTooltip { [weak self] in
                guard let self else { return }
                self.tooltipWindow.isTooltipShown = false
                self.selectedMarker = nil
            }
        }
    }
    
    func mapViewCameraIdle(_ mapView: NMFMapView) {
        print(#function)
    }
    
    
    
}
