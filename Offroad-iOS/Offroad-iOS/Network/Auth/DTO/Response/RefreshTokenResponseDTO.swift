//
//  RefreshTokenResponseDTO.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 7/15/24.
//

import Foundation

struct RefreshTokenResponseDTO: Codable {
    let message: String
    let data: RefreshTokenData
}

struct RefreshTokenData: Codable {
    let accessToken: String
    let refreshToken: String
}
