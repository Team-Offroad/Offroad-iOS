//
//  AdventuresPlaceAuthenticationRequestDTO.swift
//  Offroad-iOS
//
//  Created by 김민성 on 2024/07/18.
//

import Foundation

struct AdventuresPlaceAuthenticationRequestDTO: Codable {
    let placeId: Int
    let latitude: Double
    let longitude: Double
}
