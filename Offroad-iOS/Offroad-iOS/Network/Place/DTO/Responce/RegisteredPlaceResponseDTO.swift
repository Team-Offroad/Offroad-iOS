//
//  RegisteredPlacesReponseDTO.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 7/15/24.
//

import CoreLocation
import Foundation

struct RegisteredPlaceResponseDTO: Codable {
    let message: String
    let data: RegisteredPlacesArray
}

struct RegisteredPlacesArray: Codable {
    let places: [RegisteredPlaceInfo]
}

struct RegisteredPlaceInfo: Codable {
    let id: Int
    let name: String
    let address: String
    let shortIntroduction: String
    let placeCategory: String
    let placeArea: String
    let latitude: Double
    let longitude: Double
    let visitCount: Int
    let categoryImageUrl: String
    /*
     실제 사용되는 API 요청 메서드에서는 응답값에 distanceFromUser가 항상 포함되지만,
     현재 스웨거에서 확인되는 등록 장소 API 중 응답값에 distanceFromUser가 포함되지 않는 경우도 존재하기 때문에,
     혹시 모를 충돌을 대비하고자, distanceFromUser의 타입을 옵셔널로 지정하였음.
     추후 API의 변경에 따라 타입을 옵셔널이 아닌 Double로 지정할 수 있음.
     */
    let distanceFromUser: Double?
}

enum PlaceModelError: LocalizedError {
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

struct PlaceModel {
    
    enum Category: String {
        case cafe = "CAFFE"
        case restaurant = "RESTAURANT"
        case park = "PARK"
        case sport = "SPORT"
        case culture = "CULTURE"
    }
    
    let id: Int
    let name: String
    let address: String
    let shorIntroduction: String
    let placeCategory: Category
    let placeArea: String
    let coordinate: CLLocationCoordinate2D
    let visitCount: Int
    let categoryImageUrl: URL
    
    init(_ dto: RegisteredPlaceInfo) throws {
        self.id = dto.id
        self.name = dto.name
        self.address = dto.address
        self.shorIntroduction = dto.shortIntroduction
        if let category = Category(rawValue: dto.placeCategory) {
            self.placeCategory = category
        } else {
            throw PlaceModelError.invalidCategoryImageURL(wrongURL: dto.placeCategory)
        }
        self.placeArea = dto.placeArea
        self.coordinate = .init(latitude: dto.latitude, longitude: dto.longitude)
        self.visitCount = dto.visitCount
        if let imageURL = URL(string: dto.categoryImageUrl) {
            self.categoryImageUrl = imageURL
        } else {
            throw PlaceModelError.invalidCategoryValue(wrongValue: dto.categoryImageUrl)
        }
    }
    
}
