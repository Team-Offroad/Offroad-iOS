//
//  AdventuresAuthenticationRequestDTO.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 7/15/24.
//

import Foundation

struct AdventuresAuthenticationRequestDTO: Codable {
    let placeId: Int
    let qrCode: String
}