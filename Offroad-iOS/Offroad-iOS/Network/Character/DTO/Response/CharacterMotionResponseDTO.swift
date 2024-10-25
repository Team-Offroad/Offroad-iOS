//
//  CharacterMotionResponseDTO.swift
//  Offroad-iOS
//
//  Created by  정지원 on 9/9/24.
//

import Foundation

struct CharacterMotionResponseDTO: Codable {
    let message: String
    let data: CharacterMotionData
}

struct CharacterMotionData: Codable {
    let gainedCharacterMotions: [CharacterMotion]
    let notGainedCharacterMotions: [CharacterMotion]
}

struct CharacterMotion: Codable {
    let category: String
    let characterMotionImageUrl: String
    let isNewGained: Bool
}

struct CharacterMotionInfoData {
    
    let category: String
    let characterMotionImageUrl: String
    let isNewGained: Bool
    let isGained: Bool
    
    init(motion: CharacterMotion, isGained: Bool) {
        self.category = motion.category
        self.characterMotionImageUrl = motion.characterMotionImageUrl
        self.isNewGained = motion.isNewGained
        self.isGained = isGained
    }
    
}
