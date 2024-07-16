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
            oldValue.forEach { marker in
                marker.mapView = nil
            }
            print("-----------------", #function, "----------------")
            showMarkersOnMap()
        }
    }
    
    var searchedPlaceArray: [RegisteredPlaceInfo] = []
    
    //MARK: - Life Cycle
    
    override func loadView() {
        view = rootView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupMarkers()
        setupButtonsAction()
        requestAuthorization()
        setupDelegates()
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
        navigationController?.pushViewController(QuestQRViewController(), animated: true)
    }
    
    @objc private func pushPlaceListViewController() {
        print(#function)
        navigationController?.pushViewController(QuestQRViewController(), animated: true)
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
        rootView.naverMapView.mapView.touchDelegate = self
    }
    
    private func showMarkersOnMap() {
        shownMarkersArray.forEach { marker in
            marker.mapView = rootView.naverMapView.mapView
        }
    }
    
    private func convertSearchedPlaceToMarker(searchedPlaces: [RegisteredPlaceInfo]) {
        let markersToBeShown = searchedPlaces.map {
            let marker = NMFMarker(
                position: NMGLatLng(lat: $0.latitude, lng: $0.longitude),
                iconImage: NMFOverlayImage(image: .icnPlaceMarkerOrange)
            )
            marker.width = 25
            marker.height = 40
            return marker
        }
        shownMarkersArray = markersToBeShown
    }
    
}

//MARK: - NMFMapViewCameraDelegate

extension QuestMapViewController: NMFMapViewCameraDelegate {
    
    func mapView(_ mapView: NMFMapView, cameraDidChangeByReason reason: Int, animated: Bool) {
        let orangeLocationOverlayImage = rootView.orangeLocationOverlayImage
        self.rootView.naverMapView.mapView.locationOverlay.icon = orangeLocationOverlayImage
    }
    
}

//MARK: - NMFMapViewTouchDelegate

extension QuestMapViewController: NMFMapViewTouchDelegate {
    
    func mapView(_ mapView: NMFMapView, didTapMap latlng: NMGLatLng, point: CGPoint) {
        print(#function)
        
        print("latlng: \(latlng),  point: \(point))")
    }
    
}
