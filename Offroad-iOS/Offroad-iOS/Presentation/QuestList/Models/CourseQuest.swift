//
//  QuestDetail.swift
//  Offroad-iOS
//
//  Created by  정지원 on 3/11/25.
//

#if DevTarget
import Foundation

struct CourseQuest {
    let title: String
    let progress: String
    let description: String
    let quests: [QuestDetail]
    let reward: String
}

struct QuestDetail {
    let locationName: String
    let mission: String
}
#endif
