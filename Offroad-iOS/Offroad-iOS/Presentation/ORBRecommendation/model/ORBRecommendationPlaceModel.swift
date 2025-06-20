//
//  ORBRecommendationPlaceModel.swift
//  ORB_Dev
//
//  Created by 김민성 on 6/7/25.
//

import CoreLocation
import Foundation

enum ORBRecommendationType: String {
    case restaurant = "RESTAURANT"
    case cafe = "CAFE"
}

enum ORBRecommendationPlaceModelError: LocalizedError {
    case invalidCategoryValue(wrongValue: String)
    case invalidCategoryImageURL(wrongURL: String)
    
    var errorDescription: String? {
        switch self {
        case .invalidCategoryValue(let wrongValue):
            return "Invalid category value: \(wrongValue)"
        case .invalidCategoryImageURL(let wrongURL):
            return "Invalid category image url: \(wrongURL)"
        }
    }
}

struct ORBRecommendationPlaceModel: PlaceDescribable {
    
    let id: Int
    let name: String
    let address: String
    let shortIntroduction: String
    let placeCategory: ORBPlaceCategory
    let placeArea: String
    let visitCount: Int
    let coordinate: CLLocationCoordinate2D
    let categoryImageUrl: URL
    
    init(_ dto: ORBRecommendationPlace) throws {
        self.id = dto.id
        self.name = dto.name
        self.address = dto.address
        self.shortIntroduction = dto.shortIntroduction
        if let category = ORBPlaceCategory(rawValue: dto.placeCategory) {
            self.placeCategory = category
        } else {
            throw ORBRecommendationPlaceModelError.invalidCategoryValue(wrongValue: dto.placeCategory)
        }
        self.placeArea = dto.placeArea
        // 현재 서버 응답값에 visitCount가 포함되어있지 않아서 visitCount가 nil로 들어옴.
        // 우선 런타임 에러 막기 위해 기본값 0 할당.
        // 서버에서 visitCount 포함하여 데이터 넘겨주면 반영할 예정
        self.visitCount = dto.visitCount ?? 0
        self.coordinate = .init(latitude: dto.latitude, longitude: dto.longitude)
        if let imageURL = URL(string: dto.categoryImageUrl) {
            self.categoryImageUrl = imageURL
        } else {
            throw PlaceModelError.invalidCategoryValue(wrongValue: dto.categoryImageUrl)
        }
    }
    
}
