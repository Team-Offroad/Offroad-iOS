//
//  QuestMapViewModel.swift
//  Offroad-iOS
//
//  Created by 김민성 on 10/28/24.
//

import CoreLocation
import UIKit

import NMapsMap
import RxSwift
import RxCocoa
import SnapKit
import Then

final class QuestMapViewModel {
    
    var disposeBag = DisposeBag()
    
    private let locationManager = CLLocationManager()
    private var currentZoomLevel: Double = 14
    private var searchedPlaceArray: [RegisteredPlaceInfo] = []
    private var selectedMarker: NMFMarker? = nil
    private var isFocused: Bool = false
//    private var currentLocation: NMGLatLng = NMGLatLng(lat: 0, lng: 0)
    private var shownMarkersArray: [NMFMarker] = []
    
    
    
//    let searchedPlaceArraySubject = PublishSubject<[RegisteredPlaceInfo]>()
    let markersSubject = PublishSubject<[OffroadNMFMarker]>()
    
    let customOverlayImage = NMFOverlayImage(image: .icnQuestMapPlaceMarker)
    
    let shouldRequestLocationAuthorization = PublishSubject<Void>()
    
    
    
    init() {
        
    }
    
    
    
    func requestAuthorization() {
        let status = locationManager.authorizationStatus
        switch status {
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
        case .restricted:
            //추후 에러 메시지 팝업 구현 가능성
            //showAlert(title: "위치 접근 권한이 막혀있습니다.", message: "위치 정보 권한을 허용해 주세요")
            //tabBarController?.selectedIndex = 0
            shouldRequestLocationAuthorization.onNext(())
        case .denied:
            //showAlert(title: "위치 접근 권한이 막혀있습니다.", message: "위치 정보 권한을 허용해 주세요")
            //tabBarController?.selectedIndex = 0
            shouldRequestLocationAuthorization.onNext(())
        case .authorizedAlways:
            return
        case .authorizedWhenInUse:
            return
        @unknown default:
            return
        }
    }
    
    
    func updateRegisteredPlaces(at target: NMGLatLng) {
        
        let requestPlaceDTO = RegisteredPlaceRequestDTO(
            currentLatitude: target.lat,
            currentLongitude: target.lng,
            limit: 100,
            isBounded: true
        )
        
        NetworkService.shared.placeService.getRegisteredPlace(requestDTO: requestPlaceDTO) { [weak self] response in
            guard let self else { return }
            switch response {
            case .success(let data):
//                searchedPlaceArraySubject.onNext(data!.data.places)
                
                let markers = data!.data.places.map {
                    let marker = OffroadNMFMarker(
                        placeInfo: $0,
                        iconImage: self.customOverlayImage
                    )
                    marker.width = 26
                    marker.height = 32
//                    self.setupMarkerTouchHandler(marker: marker)
                    return marker
                }
                
                markersSubject.onNext(markers)
//                self.searchedPlaceArray = data!.data.places
//                convertSearchedPlaceToMarker(searchedPlaces: self.searchedPlaceArray)
                
            // 에러별 분기처리 필요
            default:
                return
            }
        }
    }
    
//    func updateCurrentLocation() {
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
    
//    private func convertSearchedPlaceToMarker(searchedPlaces: [RegisteredPlaceInfo]) {
//        let markersToBeShown = searchedPlaces.map {
//            let marker = OffroadNMFMarker(
//                placeInfo: $0,
//                iconImage: customOverlayImage
//            )
//            marker.width = 26
//            marker.height = 32
//            setupMarkerTouchHandler(marker: marker)
//            return marker
//        }
//        shownMarkersArray = markersToBeShown
//    }
    
//    private func setupMarkerTouchHandler(marker: OffroadNMFMarker) {
//        marker.touchHandler = { [weak self] markerOverlay in
//            guard let self else { return false }
//            
//            self.selectedMarker = marker
////            self.tooltipWindow = PlaceInfoTooltipWindow(contentFrame: contentFrame)
////            self.tooltipWindow.placeInfoViewController.shouldHideTooltip
////                .subscribe(onNext: { [weak self] in
////                    guard let self else { return }
////                    self.tooltipWindow?.placeInfoViewController.rootView.hideTooltip {
////                        self.tooltipWindow = nil
////                    }
////                }).disposed(by: disposeBag)
//            self.focusToMarker(marker)
//            self.tooltipWindow.placeInfoViewController.rootView.tooltip.configure(with: marker.placeInfo)
//            self.tooltipWindow.placeInfoViewController.rootView.tooltipAnchorPoint = convertedSelectedMarkerPosition!
//            self.tooltipWindow.placeInfoViewController.rootView.showToolTip(completion: { [weak self] in
//                guard let self else { return }
//                self.tooltipWindow.isTooltipShown = true
//            })
//            
//            return true
//        }
//    }
    
    
    
}
