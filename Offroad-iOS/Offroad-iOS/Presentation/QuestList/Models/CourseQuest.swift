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

extension CourseQuest {
    static var dummy: [CourseQuest] {
        return [
            CourseQuest(
                title: "코스 퀘스트 1",
                progress: "1/5",
                description: "첫 번째 코스 퀘스트",
                quests: [
                    QuestDetail(locationName: "장소 A", mission: "미션 1"),
                    QuestDetail(locationName: "장소 B", mission: "미션 2"),
                    QuestDetail(locationName: "장소 C", mission: "미션 3")
                ],
                reward: "보상 1"
            ),
            CourseQuest(
                title: "코스 퀘스트 2",
                progress: "2/5",
                description: "두 번째 코스 퀘스트",
                quests: [
                    QuestDetail(locationName: "장소 D", mission: "미션 4"),
                    QuestDetail(locationName: "장소 E", mission: "미션 5")
                ],
                reward: "보상 2"
            )
        ]
    }
}
#endif
