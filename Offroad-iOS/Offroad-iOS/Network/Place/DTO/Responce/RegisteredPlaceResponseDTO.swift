//
//  RegisteredPlacesReponseDTO.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 7/15/24.
//

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
    let latitude: Double
    let longitude: Double
    let visitCount: Int
}
