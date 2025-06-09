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
    
    let isLocationAuthorized = PublishRelay<Bool>()
    let isFirstVisitToday = PublishRelay<Bool>()
    let successCharacterImageUrl = PublishRelay<String>()
    let successCharacterImage = PublishSubject<UIImage?>()
    let completeQuestList = PublishRelay<[CompleteQuest]?>()
    let adventureResultSubject = PublishSubject<AdventuresPlaceAuthenticationResultData>()
    
    let startLoading = PublishRelay<Void>()
    let networkFailureSubject = PublishSubject<Void>()
    /// 지도에 표시될 마커 정보 데이터를 방출
    let markers = BehaviorRelay<[ORBNMFMarker]>(value: [])
    /// 마커 정보를 가져오는 과정에서 발생하는 에러를 방출
    let markersError = PublishRelay<Error>()
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
        
        let networkService = NetworkService.shared.placeService
        let targetCoordinate = CLLocationCoordinate2D(latitude: target.lat, longitude: target.lng)
        
        Task {
            do {
                let places = try await networkService.getRegisteredListPlaces(at: targetCoordinate, limit: 100)
                let markers = places.map {
                    let marker = ORBNMFMarker(place: $0, iconImage: customOverlayImage)
                    (marker.width, marker.height) = (26, 32)
                    return marker
                }
                // 새 마커들을 지도에 추가하기 전에 기존에 지도에 뜨던 마커들을 지도에서 제거하는 동작.
                /// - Note: 네이버 지도에 추가된 오버레이(마커 포함)의 속성은 메인 스레드에서 접근해야 하며,
                /// 그렇지 않을 경우 `NSObjectInaccessibleException` 발생.
                /// 오버레이가 지도에 추가되지 았았을 경우에 한해서 다른 스레드에서 접근 시 예외가 발생하지 않음.
                /// 비동기 컨텍스트에서 지도에 표시된 마커의 `mapView`에 값을 할당함에도 예외가 발생하지 않는 이유는 지도에서 제거하는 동작이기 때문.
                /// 만약 지도에서 제거하는 동작 외에 마커의 속성에 접근하면 에러가 발생하니, 이 경우에는 반드시
                /// `MainActor.run { ... }`
                /// 등의 코드로 감쌀 거나 코드의 위치를 메인 스레드가 동작하는 환경으로 옮겨야 함.
                self.markers.value.forEach { $0.mapView = nil }
                // 새 마커 정보 방출
                self.markers.accept(markers)
            } catch {
                self.markersError.accept(error)
            }
        }
    }
    
    func authenticatePlaceAdventure(placeInfo: PlaceModel) {
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
                latitude: placeInfo.coordinate.latitude,
                longitude: placeInfo.coordinate.longitude
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
