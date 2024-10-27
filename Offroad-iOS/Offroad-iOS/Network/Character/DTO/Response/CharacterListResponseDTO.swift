//
//  AcquiredCharacterResponseDTO.swift
//  Offroad-iOS
//
//  Created by  정지원 on 9/7/24.
//

import Foundation

struct CharacterListResponseDTO: Codable {
    let message: String
    let data: CharacterListData
}

struct CharacterListData: Codable {
    let gainedCharacters: [CharacterListInfo]
    let notGainedCharacters: [CharacterListInfo]
    let representativeCharacterId: Int
}

struct CharacterListInfo: Codable {
    let characterId: Int
    let characterName: String
    let characterThumbnailImageUrl: String
    let characterMainColorCode: String
    let characterSubColorCode: String
    let isNewGained: Bool
}

struct CharacterListInfoData {
    
    let characterId: Int
    let characterName: String
    let characterThumbnailImageUrl: String
    let characterMainColorCode: String
    let characterSubColorCode: String
    let isNewGained: Bool
    let isGained: Bool
    
    init(info: CharacterListInfo, isGained: Bool) {
        self.characterId = info.characterId
        self.characterName = info.characterName
        self.characterThumbnailImageUrl = info.characterThumbnailImageUrl
        self.characterMainColorCode = info.characterMainColorCode
        self.characterSubColorCode = info.characterSubColorCode
        self.isNewGained = info.isNewGained
        self.isGained = isGained
    }
    
}
