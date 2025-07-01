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
    let cursorId: Int
#if DevTarget
    let isCourse: Bool
    let deadline: String?
    let courseQuestPlaces: [CourseQuestPlaceDTO]?
    let questId: Int
#endif
}
#if DevTarget
struct CourseQuestPlaceDTO: Codable {
    let category: String
    let name: String
    let address: String
    let latitude: Double
    let longitude: Double
    let isVisited: Bool?
    let categoryImage: String
    let description: String
    let placeId: Int
}
#endif
