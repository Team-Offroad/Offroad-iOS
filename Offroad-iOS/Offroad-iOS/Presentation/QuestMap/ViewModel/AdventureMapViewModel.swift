//
//  AdventureMapViewModel.swift
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

final class AdventureMapViewModel: SVGFetchable {
    
    //MARK: - Properties
    
    var disposeBag = DisposeBag()
    
    let locationManager = CLLocationManager()
    private var currentZoomLevel: Double = 14
    private var searchedPlaceArray: [RegisteredPlaceInfo] = []
    private var isFocused: Bool = false
    
    let isLocationAuthorized = PublishRelay<Bool>()
    let isFirstVisitToday = PublishRelay<Bool>()
    let successCharacterImageUrl = PublishRelay<String>()
    let successCharacterImage = PublishSubject<UIImage?>()
    let completeQuestList = PublishRelay<[CompleteQuest]?>()
    let adventureResultSubject = PublishSubject<AdventuresPlaceAuthenticationResultData>()
    
    let startLoading = PublishRelay<Void>()
    let stopLoading = PublishRelay<Void>()
    let networkFailureSubject = PublishSubject<Void>()
    let didReceiveMarkers = BehaviorSubject<[ORBNMFMarker]>(value: [])
    let customOverlayImage = NMFOverlayImage(image: .icnQuestMapPlaceMarker)
    let locationUnauthorizedMessage = PublishRelay<String>()
    let locationServicesDisabledRelay = PublishRelay<Void>()
    
    var currentLocation: NMGLatLng? {
        locationManager.startUpdatingLocation()
        guard let coordinate = locationManager.location?.coordinate else { return nil }
        return NMGLatLng(lat: coordinate.latitude, lng: coordinate.longitude)
    }
    
    //MARK: - Life Cycle
    
    init() {
        successCharacterImageUrl.subscribe(onNext: { [weak self] imageUrl in
            guard let self else { return }
            self.fetchSVG(svgURLString: imageUrl) { image in
                self.successCharacterImage.onNext(image)
            }
        }).disposed(by: disposeBag)
    }
    
}

extension AdventureMapViewModel {
    
    enum LocationAuthorizationCase: Int {
        case notDetermined = 0 
        case fullAccuracy
        case reducedAccuracy
        case denied
        case restricted
        case servicesDisabled
    }
    
    //MARK: - Func
    
    func checkLocationAuthorizationStatus(completion: ((LocationAuthorizationCase) -> Void)? = nil) {
        
        DispatchQueue.global().async { [weak self] in
            guard let self else { return }
            
            guard CLLocationManager.locationServicesEnabled() else {
                self.locationServicesDisabledRelay.accept(())
                completion?(.servicesDisabled)
                return
            }
            
            let status = self.locationManager.authorizationStatus
            switch status {
            case .notDetermined:
                self.locationManager.requestWhenInUseAuthorization()
                completion?(.notDetermined)
                
                // 가족 공유 등의 기능에서 부모 혹은 보호자가 앱을 사용할 수 없도록 제한했을 때
            case .restricted:
                completion?(.restricted)
                
                /*
                 - 사용자가 앱에 위치 사용 권한을 허용하지 않은 경우
                 - 위치 서비스를 끈 경우
                 */
            case .denied:
                completion?(.denied)
                
            case .authorizedAlways, .authorizedWhenInUse:
                guard locationManager.accuracyAuthorization == .fullAccuracy else {
                    completion?(.reducedAccuracy)
                    return
                }
                completion?(.fullAccuracy)
            @unknown default:
                return
            }
        }   
    }
    
    func updateRegisteredPlaces(at target: NMGLatLng) {
        startLoading.accept(())
        NetworkService.shared.placeService.getRegisteredMapPlaces(
            latitude: target.lat,
            longitude: target.lng,
            limit: 100
        ) { [weak self] response in
            guard let self else { return }
            self.stopLoading.accept(())
            switch response {
            case .success(let data):
                let markers = data!.data.places.map {
                    return ORBNMFMarker(placeInfo: $0, iconImage: self.customOverlayImage)
                        .then { $0.width = 26; $0.height = 32 }
                }
                
                self.didReceiveMarkers.onNext(markers)
            default:
                self.networkFailureSubject.onNext(())
                return
            }
        }
    }
    
    func authenticatePlaceAdventure(placeInfo: RegisteredPlaceInfo) {
        guard let currentLocation else {
            locationUnauthorizedMessage.accept(ErrorMessages.accessingLocationDataFailure)
            return
        }
        #if DevTarget
        let dto: AdventuresPlaceAuthenticationRequestDTO
        // 개발자 모드의 설정값 확인
        let locationAuthenticationBypassing = UserDefaults.standard.bool(forKey: "bypassLocationAuthentication")
        if locationAuthenticationBypassing {
            dto = AdventuresPlaceAuthenticationRequestDTO(
                placeId: placeInfo.id,
                latitude: placeInfo.latitude,
                longitude: placeInfo.longitude
            )
        } else {
            dto = AdventuresPlaceAuthenticationRequestDTO(
                placeId: placeInfo.id,
                latitude: currentLocation.lat,
                longitude: currentLocation.lng
            )
        }
        #else
        let dto = AdventuresPlaceAuthenticationRequestDTO(
            placeId: placeInfo.id,
            latitude: currentLocation.lat,
            longitude: currentLocation.lng
        )
        #endif
        
        startLoading.accept(())
        NetworkService.shared.adventureService.authenticatePlaceAdventure(
            adventureAuthDTO: dto,
            completion: { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let data):
                    guard let data else { return }
                    self.isLocationAuthorized.accept(data.data.isValidPosition)
                    self.successCharacterImageUrl.accept(data.data.successCharacterImageUrl)
                    self.completeQuestList.accept(data.data.completeQuestList)
                    self.isFirstVisitToday.accept(data.data.isFirstVisitToday)
                default:
                    self.networkFailureSubject.onNext(())
                    return
                }
            })
    }
    
}
