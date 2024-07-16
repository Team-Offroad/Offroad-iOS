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
    
    private var markersArray: [NMFMarker] = []
    private var currentLocation: NMGLatLng = NMGLatLng(lat: 0, lng: 0)
    
    var placeArray: [RegisteredPlaceInfo] = []
    
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
        markersArray = dummyPlaces.map({ place in
            let marker = NMFMarker(position: place.latLng)
            marker.mapView = rootView.naverMapView.mapView
            marker.width = 25
            marker.height = 35
            return marker
        })
    }
    
    private func setupButtonsAction() {
        rootView.questListButton.addTarget(self, action: #selector(pushQuestListViewController), for: .touchUpInside)
        rootView.placeListButton.addTarget(self, action: #selector(pushPlaceListViewController), for: .touchUpInside)
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
            switch response {
            case .success(let data):
                DispatchQueue.global().async {
                    self?.placeArray = data!.data.places
                }
                return
            // 에러별 분기처리 필요
            default:
                return
            }
        }
    }
    
    private func setupDelegates() {
        rootView.naverMapView.mapView.addCameraDelegate(delegate: self)
    }
    
}

//MARK: - NMFMapViewCameraDelegate

extension QuestMapViewController: NMFMapViewCameraDelegate {
    
    func mapView(_ mapView: NMFMapView, cameraDidChangeByReason reason: Int, animated: Bool) {
        let orangeLocationOverlayImage = rootView.orangeLocationOverlayImage
        self.rootView.naverMapView.mapView.locationOverlay.icon = orangeLocationOverlayImage
    }
    
}
