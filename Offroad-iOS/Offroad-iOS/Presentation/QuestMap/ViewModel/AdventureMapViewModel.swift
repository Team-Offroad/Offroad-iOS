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
    
    let startLoading = PublishRelay<Void>()
    /// 지도에 표시될 마커 정보 데이터를 방출
    let markers = BehaviorRelay<[PlaceMapMarker]>(value: [])
    /// 마커 정보를 가져오는 과정에서 발생하는 에러를 방출
    let markersError = PublishRelay<Error>()
    /// 위치 인증 기반 탐험 결과와 팝업에 띄울 이미지를 함께 방출 (`AdventureResult` 타입으로 래핑)
    let placeAuthenticationResult = PublishRelay<AdventureResult>()
    /// 위치 인증 기반 탐험 과정에서 발생하는 에러를 방출
    let placeAuthenticationError = PublishRelay<Error>()
    
    let locationUnauthorizedMessage = PublishRelay<String>()
    let locationServicesDisabledRelay = PublishRelay<Void>()
    
    var currentLocation: NMGLatLng? {
        guard let coordinate = locationManager.location?.coordinate else { return nil }
        return NMGLatLng(lat: coordinate.latitude, lng: coordinate.longitude)
    }
    
    init() {
        locationManager.startUpdatingLocation()
    }
    
}

extension AdventureMapViewModel {
    
    /// 위치 정보 사용 가능 상태
    enum LocationAuthorizationCase: Int {
        /// 아직 정해지지 않음. 처음 앱을 시작하거나, 위치 접근 허용 옵션이 '다음번에 묻기 또는 내가 공유할 때' 인 경우
        case notDetermined = 0
        
        /// 위치 정보를 얻어올 수 있으면서, '정확한 위치' 옵션이 활성화된 경우.
        case fullAccuracy
        
        /// 위치 정보를 얻어올 수 있으나, '정확한 위치' 옵션이 활성화되어있지 않아 정확한 위치를 얻어올 수 없는 경우
        case reducedAccuracy
        
        /// 사용자가 위치 접근 권한을 거부한 경우
        case denied
        
        /// 가족 공유 등의 기능에서 부모 혹은 보호자가 제한했을 때
        case restricted
        
        /// 위치 서비스 자체가 불가능한 경우 (위치 서비스 기능 자체를 끈 경우)
        case servicesDisabled
    }
    
    /// 현재 위치 접근 권한 상태.
    ///
    /// 비동기적으로 반환하는 이유는
    /// 위치 서비스 여부를 묻는 `CLLocationManager.locationServicesEnabled()` 함수를 메인스레드에서 실행 시
    /// Xcode에서 경고를 띄우기 때문.
    var locationAuthorizationStatus: LocationAuthorizationCase {
        get async {
            guard CLLocationManager.locationServicesEnabled() else {
                self.locationServicesDisabledRelay.accept(())
                return .servicesDisabled
            }
            
            switch locationManager.authorizationStatus {
            case .notDetermined:
                self.locationManager.requestWhenInUseAuthorization()
                return .notDetermined
                
            case .restricted:
                return .restricted
                
            case .denied:
                return .denied
                
            case .authorizedAlways, .authorizedWhenInUse:
                if locationManager.accuracyAuthorization == .fullAccuracy {
                    return .fullAccuracy
                } else {
                    return .reducedAccuracy
                }
                
            @unknown default:
                return .servicesDisabled
            }
        }
    }
    
    /// 특정 위치를 기준으로 지도에 표시될 장소 목록을 업데이트
    /// - Parameter target: 업데이트할 기준 좌표.
    func updateRegisteredPlaces(at target: NMGLatLng) {
        startLoading.accept(())
        
        let networkService = NetworkService.shared.placeService
        let targetCoordinate = CLLocationCoordinate2D(latitude: target.lat, longitude: target.lng)
        
        Task {
            do {
                let places = try await networkService.getRegisteredListPlaces(at: targetCoordinate, limit: 100)
                let markers = places.map {
                    let marker = PlaceMapMarker(place: $0)
                    (marker.width, marker.height) = (26, 32)
                    return marker
                }
                // 새 마커들을 지도에 추가하기 전에 기존에 지도에 뜨던 마커들을 지도에서 제거하는 동작.
                /// - Note: 네이버 지도에 추가된 오버레이(마커 포함)의 속성은 메인 스레드에서 접근해야 하며,
                /// 그렇지 않을 경우 `NSObjectInaccessibleException` 발생.
                /// 오버레이가 지도에 추가되지 았았을 경우에 한해서 다른 스레드에서 접근 시 예외가 발생하지 않음.
                /// 참고) `NMFMarker` 클래스는 `MainActor`에 격리되어 있지 않음.
                await MainActor.run { [weak self] in
                    self?.markers.value.forEach { $0.mapView = nil }
                }
                // 새 마커 정보 방출
                self.markers.accept(markers)
            } catch {
                self.markersError.accept(error)
            }
        }
    }
    
    /// 위치 기반 탐험 인증을 시도.
    /// - Parameter placeInfo: 탐험을 시도할 위치 정보.
    ///
    /// 개발용 `Target`(`ORB_Dev`)에서는 개발자 모드의 설정값 중 '탐험 시 위치 인증 무시' 값에 따라 분기처리됨.
    func authenticateAdventurePlace(placeInfo: PlaceModel) {
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
        Task { [weak self] in
            do {
                let networkService = NetworkService.shared.adventureService
                // 탐험 시도 및 결과 받아오기
                let authenticationResult = try await networkService.authenticateAdventurePlace(adventureAuthDTO: dto)
                let adventureResult = try await authenticationResult.asAdventureResult(at: placeInfo)
                
                // 탐험 결과와 이미지 방출
                self?.placeAuthenticationResult.accept(adventureResult)
                
                // 탐험 성공 시 추가 로직
                if adventureResult.isAdventureSuccess {
                    AmplitudeManager.shared.trackEvent(withName: AmplitudeEventTitles.exploreSuccess)
                    MyInfoManager.shared.didSuccessAdventure.accept(())
                }
            } catch let error as NetworkResultError {
                self?.placeAuthenticationError.accept(error)
            }
        }
    }
    
}
