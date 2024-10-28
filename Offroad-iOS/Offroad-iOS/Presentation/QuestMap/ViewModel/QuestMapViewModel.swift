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
    
    //MARK: - Properties
    
    var disposeBag = DisposeBag()
    
    private let locationManager = CLLocationManager()
    private var currentZoomLevel: Double = 14
    private var searchedPlaceArray: [RegisteredPlaceInfo] = []
    var selectedMarker: NMFMarker? = nil
    private var isFocused: Bool = false
    
    let networkFailureSubject = PublishSubject<Void>()
    let markersSubject = BehaviorSubject<[OffroadNMFMarker]>(value: [])
    let customOverlayImage = NMFOverlayImage(image: .icnQuestMapPlaceMarker)
    let shouldRequestLocationAuthorization = PublishSubject<Void>()
    
}

extension QuestMapViewModel {
    
    //MARK: - Func
    
    func requestAuthorization() {
        let status = locationManager.authorizationStatus
        switch status {
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
        case .restricted:
            shouldRequestLocationAuthorization.onNext(())
        case .denied:
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
                let markers = data!.data.places.map {
                    return OffroadNMFMarker(placeInfo: $0, iconImage: self.customOverlayImage)
                        .then { $0.width = 26; $0.height = 32 }
                }
                
                markersSubject.onNext(markers)
            case .networkFail:
                self.networkFailureSubject.onNext(())
                
            default:
                return
            }
        }
    }
    
}
