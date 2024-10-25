//
//  StartingCharacterResponseDTO.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 7/15/24.
//

import Foundation

struct StartingCharacterResponseDTO: Codable {
    let message: String
    let data: StartingCharacterResponseData
}

struct StartingCharacterResponseData: Codable {
    let characters: [StartingCharacter]
}

struct StartingCharacter: Codable, Hashable {
    let id: Int
    let description: String
    let characterBaseImageUrl: String
    let name: String
    let characterCode: String
}
