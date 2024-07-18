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
        
        requestAuthorization()
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
            locationManager.requestAlwaysAuthorization()
            return
        case .denied:
            locationManager.requestAlwaysAuthorization()
        case .authorizedAlways:
            updateCurrentLocation()
        case .authorizedWhenInUse:
            locationManager.requestAlwaysAuthorization()
            updateCurrentLocation()
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
        let requestPlaceDTO = RegisteredPlaceRequestDTO(
            currentLatitude: currentLocation.lat,
            currentLongitude: currentLocation.lng
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
            print("lat: \(marker.position.lat), lng: \(marker.position.lng)")
            print(marker.placeInfo.name)
            print(marker.placeInfo.placeCategory)
            print(marker.placeInfo.address)
            print(marker.placeInfo.shortIntroduction)
            print(marker.placeInfo.address)
            print(marker.placeInfo.visitCount)
            
            let popupViewController = PlaceInfoPopupViewController(placeInfo: marker.placeInfo)
            popupViewController.modalPresentationStyle = .overCurrentContext
            popupViewController.configurePopupView()
            popupViewController.superViewControlller = self?.navigationController
            self?.present(popupViewController, animated: false)
            
            return true
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
