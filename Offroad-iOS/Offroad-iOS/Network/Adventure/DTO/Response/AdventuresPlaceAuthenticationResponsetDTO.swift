//
//  AdventuresPlaceAuthenticationResponseDTO.swift
//  Offroad-iOS
//
//  Created by 김민성 on 2024/07/18.
//

import Foundation

struct AdventuresPlaceAuthenticationResponseDTO: Codable {
    let message: String
    let data: AdventuresPlaceAuthenticationResultData
}

struct AdventuresPlaceAuthenticationResultData: Codable {
    let isValidPosition: Bool
    let successCharacterImageUrl: String
    let completeQuestList: [CompleteQuest]?
}

struct CompleteQuest: Codable {
    let name: String
}

