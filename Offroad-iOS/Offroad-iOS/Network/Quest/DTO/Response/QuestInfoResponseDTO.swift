//
//  QuestInfoResponseDTO.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 7/15/24.
//

import Foundation

struct QuestInfoResponseDTO: Codable {
    let message: String
    let data: QuestData
}

struct QuestData: Codable {
    let recent: RecentQuestData
    let almost: AlmostQuestData
}

struct RecentQuestData: Codable{
    let questName: String
    let progress: Int
    let completeCondition: Int
}

struct AlmostQuestData: Codable {
    let questName: String
    let progress: Int
    let completeCondition: Int
}
