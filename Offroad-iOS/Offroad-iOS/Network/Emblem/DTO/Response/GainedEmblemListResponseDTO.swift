//
//  GainedEmblemListResponseDTO.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 9/5/24.
//

import Foundation

struct GainedEmblemListResponseDTO: Codable {
    let message: String
    let data: GainedEmblemInfo
}

struct GainedEmblemInfo: Codable {
    let gainedEmblems: [GainedEmblemList]
}

struct GainedEmblemList: Codable {
    let emblemName: String
    let clearConditionQuestName: String
    let isNewGained: Bool
}
