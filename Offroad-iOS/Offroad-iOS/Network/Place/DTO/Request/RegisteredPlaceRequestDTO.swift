//
//  RegisteredPlaceRequestDTO.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 7/15/24.
//

import Foundation

struct RegisteredPlaceRequestDTO: Codable {
    let currentLatitude: Double
    let currentLongitude: Double
    let limit: Int
    let isBounded: Bool
}
