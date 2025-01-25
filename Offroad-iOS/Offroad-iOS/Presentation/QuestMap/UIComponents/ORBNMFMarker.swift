//
//  File.swift
//  Offroad-iOS
//
//  Created by 김민성 on 2024/07/17.
//

import UIKit

import NMapsMap
import Then

class ORBNMFMarker: NMFMarker {
    
    //MARK: - Properties
    
    let placeInfo: RegisteredPlaceInfo
    
    //MARK: - Life Cycle
    
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
        self.anchor = .init(x: 0.5, y: 1)
        self.iconPerspectiveEnabled = true
    }
    
}
