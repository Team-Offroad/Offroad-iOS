//
//  SocialLoginResponseDTO.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 7/15/24.
//

import Foundation

struct SocialLoginResponseDTO: Codable {
    let message: String
    let data: TokenData
}

struct TokenData: Codable {
    let accessToken: String
    let refreshToken: String
}
