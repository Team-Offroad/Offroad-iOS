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
    let gainedCharacterMotions: [ORBCharacterMotion]
    let notGainedCharacterMotions: [ORBCharacterMotion]
}
struct ORBCharacterMotion: Codable {
    let category: String
    let characterMotionImageUrl: String
    let isNewGained: Bool
}


