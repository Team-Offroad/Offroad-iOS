//
//  QuestListResponseDTO.swift
//  Offroad-iOS
//
//  Created by 김민성 on 8/27/24.
//

import Foundation

struct QuestListResponseDTO: Codable {
    let message: String
    let data: QuestListData
}

struct QuestListData: Codable {
    let questList: [Quest]
}

struct Quest: Codable {
    let questName: String
    let description: String
    let currentCount: Int
    let totalCount: Int
    let requirement: String
    let reward: String
}
