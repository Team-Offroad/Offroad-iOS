//
//  RegisteredPlacesReponseDTO.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 7/15/24.
//

import Foundation

struct RegisteredPlaceResponseDTO: Codable {
    let message: String
    let data: RegisteredPlaceInfo
}

struct RegisteredPlaceInfo: Codable {
    let places: [RegisteredPlaceList]
}

struct RegisteredPlaceList: Codable {
    let id: Int
    let name: String
    let address: String
    let shortIntroduction: String
    let placeCategory: String
    let latitude: Float
    let longitude: Float
    let visitCount: Int
}
