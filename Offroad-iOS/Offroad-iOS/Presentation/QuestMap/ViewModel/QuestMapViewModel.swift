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

final class QuestMapViewModel: SVGFetchable {
    
    //MARK: - Properties
    
    var disposeBag = DisposeBag()
    
    private let locationManager = CLLocationManager()
    private var currentZoomLevel: Double = 14
    private var searchedPlaceArray: [RegisteredPlaceInfo] = []
    var selectedMarker: OffroadNMFMarker? = nil
    private var isFocused: Bool = false
    
    let isLocationAdventureAuthenticated = PublishSubject<Bool>()
    let successCharacterImageUrl = PublishSubject<String>()
    let successCharacterImage = BehaviorSubject<UIImage?>(value: nil)
    let completeQuestList = BehaviorSubject<[CompleteQuest]?>(value: [])
    let adventureResultSubject = PublishSubject<AdventuresPlaceAuthenticationResultData>()
    
    let networkFailureSubject = PublishSubject<Void>()
    let markersSubject = BehaviorSubject<[OffroadNMFMarker]>(value: [])
    let customOverlayImage = NMFOverlayImage(image: .icnQuestMapPlaceMarker)
    let shouldRequestLocationAuthorization = PublishSubject<Void>()
    
    var currentLocation: NMGLatLng? {
        guard let coordinate = locationManager.location?.coordinate else { return nil }
        return NMGLatLng(lat: coordinate.latitude, lng: coordinate.longitude)
    }
    
    //MARK: - Life Cycle
    
    init() {
        successCharacterImageUrl
            .subscribe(onNext: { [weak self] imageUrl in
                guard let self else { return }
                self.fetchSVG(svgURLString: imageUrl) { image in
                    self.successCharacterImage.onNext(image)
                }
            }).disposed(by: disposeBag)
        
        
        
    }
    
    
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
    
    func authenticatePlaceAdventure(placeInfo: RegisteredPlaceInfo) {
        guard let currentLocation else {
            shouldRequestLocationAuthorization.onNext(())
            return
        }
        let dto = AdventuresPlaceAuthenticationRequestDTO(
            placeId: placeInfo.id,
            latitude: currentLocation.lat,
            longitude: currentLocation.lng
        )
        
        NetworkService.shared.adventureService.authenticatePlaceAdventure(
            adventureAuthDTO: dto,
            completion: { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let data):
                    guard let data else { return }
                    self.isLocationAdventureAuthenticated.onNext(data.data.isValidPosition)
                    self.successCharacterImageUrl.onNext(data.data.successCharacterImageUrl)
                    self.completeQuestList.onNext(data.data.completeQuestList)
                case .networkFail:
                    self.networkFailureSubject.onNext(())
                default:
                    return
                }
            })
    }
    
}
