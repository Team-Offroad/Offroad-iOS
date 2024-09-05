//
//  EmblemListResponseDTO.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 9/5/24.
//

import Foundation

struct EmblemListResponseDTO: Codable {
    let message: String
    let data: EmblemData
}

struct EmblemData: Codable {
    let gainedEmblems: [EmblemDataList]
    let notGainedEmblems: [EmblemDataList]
}

struct EmblemDataList: Codable {
    let emblemName: String
    let clearConditionQuestName: String
    let isNewGained: Bool
}
