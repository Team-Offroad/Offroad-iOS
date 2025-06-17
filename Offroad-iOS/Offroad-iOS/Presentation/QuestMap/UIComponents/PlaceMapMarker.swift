//
//  PlaceMapMarker.swift
//  Offroad-iOS
//
//  Created by 김민성 on 2024/07/17.
//

import UIKit

import NMapsMap

/// 탐험 지도에 띄울 보라색 마커.
class PlaceMapMarker: NMFMarker {
    
    //MARK: - Properties
    
    /// 마커가 띄울 장소 정보.
    let place: PlaceModel
    
    //MARK: - Life Cycle
    
    init(place: PlaceModel) {
        self.place = place
        super.init()
        
        self.position = NMGLatLng(
            lat: place.coordinate.latitude,
            lng: place.coordinate.longitude
        )
        // 오버레이 생성 시 `NMFOverlayImage` 인스턴스를 각각 생성하지만,
        // 같은 리소스를 참조하므로 네이버 SDK 개발 문서에서 말한 것에 적합.
        // 다음 링크 참고: https://navermaps.github.io/ios-map-sdk/guide-ko/5-1.html
        self.iconImage = NMFOverlayImage(image: .icnQuestMapPlaceMarker)
        self.anchor = .init(x: 0.5, y: 1)
        self.iconPerspectiveEnabled = true
    }
    
}
