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
    
    private var currentLocation: NMGLatLng = NMGLatLng(lat: 0, lng: 0)
    private var shownMarkersArray: [NMFMarker] = [] {
        didSet {
            oldValue.forEach { $0.mapView = nil }
            showMarkersOnMap()
        }
    }
    
    //MARK: - UI Properties
    
    let customOverlayImage = NMFOverlayImage(image: .icnPlaceMarkerOrange)
    
    var searchedPlaceArray: [RegisteredPlaceInfo] = []
    
    //MARK: - Life Cycle
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 더미 데이터로 마커 초기 설정
        //setupMarkers()
        setupButtonsAction()
        setupDelegates()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        requestAuthorization()
        updateRegisteredLocation()
    }
    
}

extension QuestMapViewController {
    
    //MARK: - @objc
    
    @objc private func reloadPlaceButtonTapped() {
        updateCurrentLocation()
        updateRegisteredLocation()
        showMarkersOnMap()
    }
    
    @objc private func pushQuestListViewController() {
        print(#function)
        //navigationController?.pushViewController(QuestQRViewController(), animated: true)
    }
    
    @objc private func pushPlaceListViewController() {
        print(#function)
        //navigationController?.pushViewController(QuestQRViewController(), animated: true)
    }
    
    //MARK: - Private Func
    
    private func setupMarkers() {
        shownMarkersArray = dummyPlaces.map({ place in
            let marker = NMFMarker(position: place.latLng)
            marker.mapView = rootView.naverMapView.mapView
            marker.width = 25
            marker.height = 35
            return marker
        })
    }
    
    private func setupButtonsAction() {
        rootView.reloadPlaceButton
            .addTarget(self, action: #selector(reloadPlaceButtonTapped), for: .touchUpInside)
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
        guard let location = locationManager.location else {
            // 위치 정보 가져올 수 없음.
            return
        }
        currentLocation = NMGLatLng(
            lat: location.coordinate.latitude,
            lng: location.coordinate.longitude
        )
        
    }
    
    private func updateRegisteredLocation() {
        let cameraPositionTarget = rootView.naverMapView.mapView.cameraPosition.target
        
        let requestPlaceDTO = RegisteredPlaceRequestDTO(
            currentLatitude: cameraPositionTarget.lat,
            currentLongitude: cameraPositionTarget.lng
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
            marker.width = 48
            marker.height = 48
            setupMarkerTouchHandler(marker: marker)
            return marker
        }
        shownMarkersArray = markersToBeShown
    }
    
    private func setupMarkerTouchHandler(marker: OffroadNMFMarker) {
        marker.touchHandler = { [weak self] markerOverlay in
            print("marker tapped")
            
            guard let locationManager = self?.locationManager else { return true }
            self?.focusToMarker(marker)
            let popupViewController = PlaceInfoPopupViewController(placeInfo: marker.placeInfo, locationManager: locationManager, marker: marker)
            popupViewController.modalPresentationStyle = .overFullScreen
            popupViewController.configurePopupView()
            popupViewController.superViewControlller = self?.navigationController
            popupViewController.marker.hidden = true
            self?.tabBarController?.present(popupViewController, animated: false)
            
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
    
}

//MARK: - NMFMapViewCameraDelegate

extension QuestMapViewController: NMFMapViewCameraDelegate {
    
    func mapView(_ mapView: NMFMapView, cameraDidChangeByReason reason: Int, animated: Bool) {
        let orangeLocationOverlayImage = rootView.orangeLocationOverlayImage
        self.rootView.naverMapView.mapView.locationOverlay.icon = orangeLocationOverlayImage
    }
    
}
