//
//  QuestMapViewController.swift
//  Offroad-iOS
//
//  Created by 김민성 on 2024/07/07.
//

import CoreLocation
import UIKit

import NMapsMap
import SnapKit
import Then

class QuestMapViewController: OffroadTabBarViewController {
    
    //MARK: - Properties
    
    private let rootView = QuestMapView()
    private let locationManager = CLLocationManager()
    private let dummpyPlace = dummyPlaces
    private let locationService = RegisteredPlaceService()
    private var currentZoomLevel: Double = 14
    private var searchedPlaceArray: [RegisteredPlaceInfo] = []
    private var selectedMarker: NMFMarker? = nil
    
    private var currentLocation: NMGLatLng = NMGLatLng(lat: 0, lng: 0)
    private var shownMarkersArray: [NMFMarker] = [] {
        didSet {
            oldValue.forEach { $0.mapView = nil }
            showMarkersOnMap()
        }
    }
    
    private var selectedMarkerPosition: CGPoint? {
        guard let selectedMarker else { return nil }
        return rootView.naverMapView.mapView.projection.point(from: selectedMarker.position)
    }
    private var convertedSelectedMarkerPosition: CGPoint? {
        guard let selectedMarker else { return nil }
        return self.rootView.naverMapView.mapView.convert(selectedMarkerPosition!, to: self.rootView)
    }
    
    //MARK: - UI Properties
    
    //let customOverlayImage = NMFOverlayImage(image: .icnPlaceMarkerOrange)
    let customOverlayImage = NMFOverlayImage(image: .icnQuestMapPlaceMarker)
    var tooltipWindow: PlaceInfoTooltipWindow? = nil
    
    //MARK: - Life Cycle
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupButtonsAction()
        setupDelegates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        navigationController?.navigationBar.isHidden = true
        guard let offroadTabBarController = tabBarController as? OffroadTabBarController else { return }
        offroadTabBarController.showTabBarAnimation()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        requestAuthorization()
        updateRegisteredLocation()
        rootView.naverMapView.mapView.positionMode = .compass
        let orangeLocationOverlayImage = rootView.orangeLocationOverlayImage
        rootView.naverMapView.mapView.locationOverlay.icon = orangeLocationOverlayImage
    }
    
}

extension QuestMapViewController {
    
    //MARK: - @objc
    
    @objc private func reloadPlaceButtonTapped() {
        updateCurrentLocation()
        updateRegisteredLocation()
        showMarkersOnMap()
    }
    
    @objc private func switchTrackingMode() {
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
    
    @objc private func pushQuestListViewController() {
        print(#function)
        navigationController?.pushViewController(QuestListViewController(), animated: true)
    }
    
    @objc private func pushPlaceListViewController() {
        print(#function)
        navigationController?.pushViewController(PlaceListViewController(), animated: true)
    }
    
    //MARK: - Private Func
    
    private func setupButtonsAction() {
        rootView.reloadPlaceButton
            .addTarget(self, action: #selector(reloadPlaceButtonTapped), for: .touchUpInside)
        rootView.switchTrackingModeButton
            .addTarget(self, action: #selector(switchTrackingMode), for: .touchUpInside)
        rootView.questListButton
            .addTarget(self, action: #selector(pushQuestListViewController), for: .touchUpInside)
        rootView.placeListButton
            .addTarget(self, action: #selector(pushPlaceListViewController), for: .touchUpInside)
    }
    
    private func requestAuthorization() {
        let status = locationManager.authorizationStatus
        switch status {
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
        case .restricted:
            //추후 에러 메시지 팝업 구현 가능성
            showAlert(title: "위치 접근 권한이 막혀있습니다.", message: "위치 정보 권한을 허용해 주세요")
            tabBarController?.selectedIndex = 0
            return
        case .denied:
            showAlert(title: "위치 접근 권한이 막혀있습니다.", message: "위치 정보 권한을 허용해 주세요")
            tabBarController?.selectedIndex = 0
        case .authorizedAlways:
            return
        case .authorizedWhenInUse:
            return
        @unknown default:
            return
        }
    }
    
    private func updateCurrentLocation() {
        guard let currentCoordinate = locationManager.location?.coordinate else {
            // 위치 정보 가져올 수 없음.
            return
        }
        currentLocation = NMGLatLng(
            lat: currentCoordinate.latitude,
            lng: currentCoordinate.longitude
        )
        print("latitude: \(currentCoordinate.latitude)")
        print("longitude: \(currentCoordinate.longitude)")
    }
    
    private func updateRegisteredLocation() {
        let cameraPositionTarget = rootView.naverMapView.mapView.cameraPosition.target
        
        let requestPlaceDTO = RegisteredPlaceRequestDTO(
            currentLatitude: cameraPositionTarget.lat,
            currentLongitude: cameraPositionTarget.lng,
            limit: 100,
            isBounded: true
        )
        
        locationService.getRegisteredLocation(requestDTO: requestPlaceDTO) { [weak self] response in
            guard let self else { return }
            switch response {
            case .success(let data):
                self.searchedPlaceArray = data!.data.places
                convertSearchedPlaceToMarker(searchedPlaces: self.searchedPlaceArray)
                
            // 에러별 분기처리 필요
            default:
                return
            }
        }
    }
    
    private func setupDelegates() {
        rootView.naverMapView.mapView.addCameraDelegate(delegate: self)
    }
    
    private func showMarkersOnMap() {
        shownMarkersArray.forEach { marker in
            marker.mapView = rootView.naverMapView.mapView
        }
    }
    
    private func convertSearchedPlaceToMarker(searchedPlaces: [RegisteredPlaceInfo]) {
        let markersToBeShown = searchedPlaces.map {
            let marker = OffroadNMFMarker(
                placeInfo: $0,
                iconImage: customOverlayImage
            )
            marker.width = 26
            marker.height = 32
            setupMarkerTouchHandler(marker: marker)
            return marker
        }
        shownMarkersArray = markersToBeShown
    }
    
    private func setupMarkerTouchHandler(marker: OffroadNMFMarker) {
        marker.touchHandler = { [weak self] markerOverlay in
            guard let self else { return false }
            
            let naverMapViewFrame = self.rootView.naverMapView.frame
            let contentFrame = CGRect(
                origin: naverMapViewFrame.origin,
                size: .init(width: naverMapViewFrame.width,
                            height: naverMapViewFrame.height - (view.safeAreaInsets.bottom + 107)
                           )
            )
            self.selectedMarker = marker
            self.tooltipWindow = PlaceInfoTooltipWindow(contentFrame: contentFrame)
            self.tooltipWindow?.makeKeyAndVisible()
            
            print("marker tapped")
            print("selectedMarkerPosition: ", selectedMarkerPosition!)
            print("convertedSelectedMarkerPosition: ", convertedSelectedMarkerPosition!)
            self.tooltipWindow?.placeInfoViewController.rootView.tooltip.configure(with: marker.placeInfo)
            self.tooltipWindow?.placeInfoViewController.rootView.tooltipAnchorPoint = convertedSelectedMarkerPosition!
            self.tooltipWindow?.placeInfoViewController.rootView.showToolTip()
            
            return true
        }
    }
    
    private func focusToMarker(_ marker: OffroadNMFMarker) {
        currentZoomLevel = rootView.naverMapView.mapView.zoomLevel
        let markerLatLng = NMGLatLng(lat: marker.placeInfo.latitude, lng: marker.placeInfo.longitude)
        let cameraUpdate = NMFCameraUpdate(scrollTo: markerLatLng)
        cameraUpdate.animation = .easeOut
        rootView.naverMapView.mapView.moveCamera(cameraUpdate)
    }
    
    private func showAlert(title: String, message: String) {
        print(#function)
        DispatchQueue.main.async { [weak self] in
            let alertCon = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
            let okAction = UIAlertAction(title: "넵!", style: .default)
            alertCon.addAction(okAction)
            
            self?.present(alertCon, animated: true)
        }
    }
    
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
        if reason == -2 {
            let orangeLocationOverlayImage = rootView.orangeLocationOverlayImage
            rootView.naverMapView.mapView.locationOverlay.icon = orangeLocationOverlayImage
            rootView.naverMapView.mapView.locationOverlay.subIcon = nil
        }
        
        if let selectedMarker, let tooltipWindow {
            tooltipWindow.placeInfoViewController.rootView.tooltipAnchorPoint = convertedSelectedMarkerPosition!
            tooltipWindow.placeInfoViewController.rootView.hideTooltip { [weak self] in
                guard let self else { return }
                self.tooltipWindow = nil
            }
        }
    }
    
    func mapView(_ mapView: NMFMapView, cameraIsChangingByReason reason: Int) {
        if let selectedMarker, let tooltipWindow {
            tooltipWindow.placeInfoViewController.rootView.tooltipAnchorPoint = convertedSelectedMarkerPosition!
//            tooltipWindow.placeInfoViewController.rootView.hideTooltip { [weak self] in
//                guard let self else { return }
//                self.tooltipWindow = nil
//            }
        }
    }
    
    func mapView(_ mapView: NMFMapView, cameraDidChangeByReason reason: Int, animated: Bool) {
        
        let orangeLocationOverlayImage = rootView.orangeLocationOverlayImage
        rootView.naverMapView.mapView.locationOverlay.icon = orangeLocationOverlayImage
        if reason == -1 {
            rootView.naverMapView.mapView.locationOverlay.subIcon = nil
        }
        
        if let selectedMarker, let tooltipWindow {
            tooltipWindow.placeInfoViewController.rootView.tooltipAnchorPoint = convertedSelectedMarkerPosition!
//            tooltipWindow.placeInfoViewController.rootView.hideTooltip { [weak self] in
//                guard let self else { return }
//                self.tooltipWindow = nil
//            }
        }
    }
    
    
    
}
