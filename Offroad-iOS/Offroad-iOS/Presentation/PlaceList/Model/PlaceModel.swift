//
//  PlaceModel.swift
//  Offroad-iOS
//
//  Created by 김민성 on 5/20/25.
//

import CoreLocation
import Foundation

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
    let shortIntroduction: String
    let placeCategory: Category
    let placeArea: String
    let coordinate: CLLocationCoordinate2D
    let visitCount: Int
    let categoryImageUrl: URL
    // 장소 목록 데이터를 불러올 때 페이징 시 필요한 값.
    let distanceFromUser: Double?
    
    init(_ dto: RegisteredPlaceInfo) throws {
        self.id = dto.id
        self.name = dto.name
        self.address = dto.address
        self.shortIntroduction = dto.shortIntroduction
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
        self.distanceFromUser = dto.distanceFromUser
    }
    
}
