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
    case invalidRecommendationType(wrongValue: String)
    case invalidCategoryValue(wrongValue: String)
    case invalidCategoryImageURL(wrongURL: String)
    
    var errorDescription: String? {
        switch self {
        case .invalidRecommendationType(wrongValue: let wrongValue):
            return "잘못된 오브의 장소 추천 타입: \(wrongValue). 오브의 장소 추천 타입은 식당, 카페 중 하나여야 합니다."
        case .invalidCategoryValue(let wrongValue):
            return "Invalid category value: \(wrongValue)"
        case .invalidCategoryImageURL(let wrongURL):
            return "Invalid category image url: \(wrongURL)"
        }
    }
}

struct ORBRecommendationPlaceModel {
    
    let id: Int
    let recommendationType: ORBRecommendationType
    let name: String
    let address: String
    let shortIntroduction: String
    let placeCategory: PlaceCategory
    let placeArea: String
    let coordinate: CLLocationCoordinate2D
    let categoryImageUrl: URL
    
    init(_ dto: ORBRecommendationPlace) throws {
        self.id = dto.id
        if let recommendationType = ORBRecommendationType(rawValue: dto.recommendationType) {
            self.recommendationType = recommendationType
        } else {
            throw ORBRecommendationPlaceModelError.invalidRecommendationType(wrongValue: dto.recommendationType)
        }
        self.name = dto.name
        self.address = dto.address
        self.shortIntroduction = dto.shortIntroduction
        if let category = PlaceCategory(rawValue: dto.placeCategory) {
            self.placeCategory = category
        } else {
            throw ORBRecommendationPlaceModelError.invalidCategoryValue(wrongValue: dto.placeCategory)
        }
        self.placeArea = dto.placeArea
        self.coordinate = .init(latitude: dto.latitude, longitude: dto.longitude)
        if let imageURL = URL(string: dto.categoryImageUrl) {
            self.categoryImageUrl = imageURL
        } else {
            throw PlaceModelError.invalidCategoryValue(wrongValue: dto.categoryImageUrl)
        }
    }
    
}
