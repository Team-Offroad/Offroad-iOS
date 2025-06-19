//
//  ORBRecommendationPlacesResponseDTO.swift
//  Offroad-iOS
//
//  Created by 김민성 on 6/7/25.
//

struct ORBRecommendationPlacesResponseDTO: Decodable {
    var message: String
    var data: ORBRecommendationResponseData
}

struct ORBRecommendationResponseData: Decodable {
    var recommendations: [ORBRecommendationPlace]
}

struct ORBRecommendationPlace: Decodable {
    let id: Int
    let recommendationType: String
    let name: String
    let address: String
    let shortIntroduction: String
    let placeCategory: String
    let placeArea: String
    let visitCount: Int?
    let latitude: Double
    let longitude: Double
    let categoryImageUrl: String
}
