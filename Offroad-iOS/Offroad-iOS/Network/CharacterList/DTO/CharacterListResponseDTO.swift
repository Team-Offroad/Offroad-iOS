//
//  AcquiredCharacterResponseDTO.swift
//  Offroad-iOS
//
//  Created by  정지원 on 9/7/24.
//

import Foundation

struct CharacterListResponseDTO: Codable {
    let message: String
    let data: CharacterListInfo
}

struct CharacterListInfo: Codable {
    let gainedCharacters: [CharacterListData]
    let notGainedCharacters: [CharacterListData]
    let representativeCharacterId: Int?
}

struct CharacterListData: Codable {
    let characterId: Int
    let characterName: String
    let characterThumbnailImageUrl: String
    let characterMainColorCode: String
    let characterSubColorCode: String
    let isNewGained: Bool
}

