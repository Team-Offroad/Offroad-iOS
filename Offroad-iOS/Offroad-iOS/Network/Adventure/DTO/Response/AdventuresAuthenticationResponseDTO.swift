//
//  AdventuresAuthenticationResponseDTO.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 7/15/24.
//

import Foundation

struct AdventuresAuthenticationResponseDTO: Codable {
    let message: String
    let data: AdventuresAuthenticationResultData
}

struct AdventuresAuthenticationResultData: Codable {
    let isQRMatched: Bool
}