//
//  PlaceListDummyDataManager.swift
//  Offroad-iOS
//
//  Created by 김민성 on 8/4/24.
//

import Foundation

class PlaceListDummyDataManager {
    
    static func makeDummyData() -> [RegisteredPlaceInfo] {
        
        let placeInfo = RegisteredPlaceInfo(
            id: 0,
            name: "브릭루즈",
            address: "경기도 파주시 지목로 143",
            shortIntroduction: "파주 브런치 맛집 대형 카페",
            placeCategory: "카페",
            latitude: 0,
            longitude: 0,
            visitCount: 332
        )
        
        let array: [RegisteredPlaceInfo] = .init(repeating: placeInfo, count: 60)
        return array
    }
    
}
