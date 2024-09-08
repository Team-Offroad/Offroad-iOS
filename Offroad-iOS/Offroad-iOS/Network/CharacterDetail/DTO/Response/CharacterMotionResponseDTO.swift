//
//  CharacterMotionResponseDTO.swift
//  Offroad-iOS
//
//  Created by  정지원 on 9/9/24.
//

import Foundation

struct CharacterMotionResponseDTO: Codable {
    let message: String
    let data: CharacterMotionInfo
}

struct CharacterMotionInfo: Codable {
    let gainedCharacterMotion: [GainedCharacterMotionList]
    let notGainedCharacterMotion: [NotGainedCharacterMotionList]
}

struct GainedCharacterMotionList: Codable {
    let category: String
    let characterMotionImageUrl: String
    let isNewGained: Bool
}

struct NotGainedCharacterMotionList: Codable {
    let category: String
    let characterMotionImageUrl: String
    let isNewGained: Bool
}


