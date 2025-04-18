//
//  AdventuresAuthenticationResponseDTO.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 7/15/24.
//

import Foundation

struct AdventuresQRAuthenticationResponseDTO: Codable {
    let message: String
    let data: AdventuresQRAuthenticationResultData
}

struct AdventuresQRAuthenticationResultData: Codable {
    let isQRMatched: Bool
    let characterImageUrl: String
}
