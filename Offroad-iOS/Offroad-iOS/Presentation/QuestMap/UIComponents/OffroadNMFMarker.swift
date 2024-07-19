//
//  File.swift
//  Offroad-iOS
//
//  Created by 김민성 on 2024/07/17.
//

import UIKit

import NMapsMap
import Then

class OffroadNMFMarker: NMFMarker {
    
    let placeInfo: RegisteredPlaceInfo
    
    init(placeInfo: RegisteredPlaceInfo) {
        self.placeInfo = placeInfo
    }
    
    convenience init(placeInfo: RegisteredPlaceInfo, iconImage: NMFOverlayImage) {
        self.init(placeInfo: placeInfo)
        self.position = NMGLatLng(
            lat: placeInfo.latitude,
            lng: placeInfo.longitude
        )
        self.iconImage = iconImage
    }
    
}
