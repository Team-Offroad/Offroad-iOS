//
//  ORBMapViewModel.swift
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

final class ORBMapViewModel: SVGFetchable {
    
    //MARK: - Properties
    
    var disposeBag = DisposeBag()
    
    let locationManager = CLLocationManager()
    private var currentZoomLevel: Double = 14
    private var searchedPlaceArray: [RegisteredPlaceInfo] = []
    private var isFocused: Bool = false
    
    let isLocationAuthorized = PublishSubject<Bool>()
    let isFirstVisitToday = PublishRelay<Bool>()
    let successCharacterImageUrl = PublishSubject<String>()
    let successCharacterImage = PublishSubject<UIImage?>()
    let completeQuestList = PublishSubject<[CompleteQuest]?>()
    let adventureResultSubject = PublishSubject<AdventuresPlaceAuthenticationResultData>()
    
    let startLoading = PublishRelay<Void>()
    let stopLoading = PublishRelay<Void>()
    let networkFailureSubject = PublishSubject<Void>()
    let markersSubject = BehaviorSubject<[OffroadNMFMarker]>(value: [])
    let customOverlayImage = NMFOverlayImage(image: .icnQuestMapPlaceMarker)
    let shouldRequestLocationAuthorization = PublishRelay<Void>()
    let locationServiceDisabledRelay = PublishRelay<Void>()
    
    var isCompassMode = false
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

extension ORBMapViewModel {
    
    //MARK: - Func
    
    func requestAuthorization() {
        let status = locationManager.authorizationStatus
        switch status {
        case .notDetermined:
            locationManager.requestWhenInUseAuthorization()
            
            // 가족 공유 등의 기능에서 부모 혹은 보호자가 앱을 사용할 수 없도록 제한했을 때
        case .restricted:
            shouldRequestLocationAuthorization.accept(())
            
            /*
             - 사용자가 앱에 위치 사용 권한을 허용하지 않은 경우
             - 위치 서비스를 끈 경우
             - 비행기 모드로 인해 위치 서비스 사용이 불가한 경우
             */
        case .denied:
            shouldRequestLocationAuthorization.accept(())
        case .authorizedAlways:
            return
        case .authorizedWhenInUse:
            return
        @unknown default:
            return
        }
    }
    
    func updateRegisteredPlaces(at target: NMGLatLng) {
        startLoading.accept(())
        let requestPlaceDTO = RegisteredPlaceRequestDTO(
            currentLatitude: target.lat,
            currentLongitude: target.lng,
            limit: 100,
            isBounded: false
        )
        
        NetworkService.shared.placeService.getRegisteredPlace(requestDTO: requestPlaceDTO) { [weak self] response in
            guard let self else { return }
            self.stopLoading.accept(())
            switch response {
            case .success(let data):
                let markers = data!.data.places.map {
                    return OffroadNMFMarker(placeInfo: $0, iconImage: self.customOverlayImage)
                        .then { $0.width = 26; $0.height = 32 }
                }
                
                self.markersSubject.onNext(markers)
            default:
                self.networkFailureSubject.onNext(())
                return
            }
        }
    }
    
    func authenticatePlaceAdventure(placeInfo: RegisteredPlaceInfo) {
        guard locationManager.authorizationStatus == .authorizedAlways
                || locationManager.authorizationStatus == .authorizedWhenInUse else {
            print(locationManager.authorizationStatus.rawValue)
            shouldRequestLocationAuthorization.accept(())
            return
        }
        guard let currentLocation else {
            shouldRequestLocationAuthorization.accept(())
            return
        }
        let dto = AdventuresPlaceAuthenticationRequestDTO(
            placeId: placeInfo.id,
            latitude: currentLocation.lat,
            longitude: currentLocation.lng
        )
        
        startLoading.accept(())
        NetworkService.shared.adventureService.authenticatePlaceAdventure(
            adventureAuthDTO: dto,
            completion: { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let data):
                    guard let data else { return }
                    self.isLocationAuthorized.onNext(data.data.isValidPosition)
                    self.successCharacterImageUrl.onNext(data.data.successCharacterImageUrl)
                    self.completeQuestList.onNext(data.data.completeQuestList)
                    self.isFirstVisitToday.accept(data.data.isFirstVisitToday)
                default:
                    self.networkFailureSubject.onNext(())
                    return
                }
            })
    }
    
    /// 어떤 마커의 위치에서 툴팁이 떴을 때 특정 영역에서 툴팁이 온전히 보이기 위해 화면상에서 마커가 최소한으로 이동해야 하는 거리를 계산하는 함수.
    /// - Parameters:
    ///   - point: 마커의 위치
    ///   - rect: 마커가 존재하는 지도의 frame
    ///   - tooltipSize: 툴팁의 frame의 크기
    ///   - inset: 지도에서 툴팁이 뜰 때 적용될 inset값
    /// - Returns: 툴팁이 온전히 보이기 위해 마커가 최소한으로 이동해야 하는 가로, 세로 point를 각각 x, y 속성으로 갖는 CGPoint
    func caculateDeltaToShowTooltip(point: CGPoint, at rect: CGRect, tooltipSize: CGSize, contentInset inset: CGFloat = 0) -> CGPoint {
        var delta: CGPoint = .zero
        
        if point.x < (tooltipSize.width/2 + inset) {
            delta.x = (tooltipSize.width/2 + inset) - point.x
        } else if point.x > rect.width - tooltipSize.width/2 - inset {
            delta.x = (rect.width - tooltipSize.width/2 - inset) - point.x
        }
        
        // 툴팁의 아래는 마커의 위치로부터 17만큼 위로 떨어져 있음. 마커의 중앙에 툴팁의 꼭짓점이 위치해야 하기 때문.
        if point.y < tooltipSize.height + 17 + inset {
            delta.y = tooltipSize.height + 17 + inset - point.y
        }
        return delta
    }
    
}
