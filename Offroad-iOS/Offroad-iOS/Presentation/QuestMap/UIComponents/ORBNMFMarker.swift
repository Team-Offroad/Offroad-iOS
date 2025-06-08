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
    
    let place: PlaceModel
    
    //MARK: - Life Cycle
    
    init(place: PlaceModel) {
        self.place = place
    }
    
    convenience init(place: PlaceModel, iconImage: NMFOverlayImage) {
        self.init(place: place)
        self.position = NMGLatLng(
            lat: place.coordinate.latitude,
            lng: place.coordinate.longitude
        )
        self.iconImage = iconImage
        self.anchor = .init(x: 0.5, y: 1)
        self.iconPerspectiveEnabled = true
    }
    
}
