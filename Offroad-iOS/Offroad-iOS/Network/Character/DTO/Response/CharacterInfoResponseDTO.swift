//
//  CharacterInfoResponseDTO.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 7/15/24.
//

import Foundation

struct CharacterInfoResponseDTO: Codable {
    let message: String
    let data: CharacterInfo
}

struct CharacterInfo: Codable {
    let characters: [ORBCharacter]
}

struct ORBCharacter: Codable, Hashable {
    let id: Int
    let description: String
    let characterBaseImageUrl: String
    let name: String
    let characterCode: String
}
