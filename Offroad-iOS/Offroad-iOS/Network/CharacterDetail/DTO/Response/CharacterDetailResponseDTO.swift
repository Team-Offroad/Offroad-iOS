//
//  CharacterDetailResponseDTO.swift
//  Offroad-iOS
//
//  Created by  정지원 on 9/8/24.
//

import Foundation

struct CharacterDetailResponseDTO: Codable {
    let message: String
    let data: CharacterDetailInfo
}

struct CharacterDetailInfo: Codable {
    let characterId: Int
    let characterName: String
    let characterBaseImageUrl: String
    let characterIconImageUrl: String
    let characterDescription: String
    let characterSummaryDescription: String
    let characterMainColorCode: String
    let characterSubColorCode: String
    let representativeCharacterId: Int?
}



