//
//  QuestDetail.swift
//  Offroad-iOS
//
//  Created by  정지원 on 3/11/25.
//

//#if DevTarget
//import Foundation
//
//struct CourseQuest {
//    let title: String
//    let progress: String
//    let description: String
//    let quests: [QuestDetail]
//    let reward: String
//    let dday: String
//}
//
//struct QuestDetail {
//    let locationName: String
//    let mission: String
//}
//
//extension CourseQuest {
//    init(from dto: CourseQuestDTO) {
//        self.title = dto.questName
//        self.progress = "\(dto.currentCount)/\(dto.totalCount)"
//        self.description = dto.description
//        self.reward = dto.reward
//        self.dday = CourseQuest.calculateDday(from: dto.deadline)
//        self.quests = dto.courseQuestPlaces.map {
//            QuestDetail(locationName: $0.name, mission: $0.description)
//        }
//    }
//
//    private static func calculateDday(from deadline: String) -> String {
//        let formatter = ISO8601DateFormatter()
//        guard let deadlineDate = formatter.date(from: deadline) else { return "D-?" }
//        let daysLeft = Calendar.current.dateComponents([.day], from: Date(), to: deadlineDate).day ?? 0
//        return daysLeft >= 0 ? "D-\(daysLeft)" : "종료"
//    }
//}
//
////extension CourseQuest {
////    static var dummy: [CourseQuest] {
////        return [
////            CourseQuest(
////                title: "코스 퀘스트 1",
////                progress: "1/5",
////                description: "첫 번째 코스 퀘스트",
////                quests: [
////                    QuestDetail(locationName: "장소 A", mission: "미션 1"),
////                    QuestDetail(locationName: "장소 B", mission: "미션 2"),
////                    QuestDetail(locationName: "장소 C", mission: "미션 3")
////                ],
////                reward: "보상 1",
////                dday: "D-5"
////            ),
////            CourseQuest(
////                title: "코스 퀘스트 2",
////                progress: "2/5",
////                description: "두 번째 코스 퀘스트",
////                quests: [
////                    QuestDetail(locationName: "장소 D", mission: "미션 4"),
////                    QuestDetail(locationName: "장소 E", mission: "미션 5")
////                ],
////                reward: "보상 2",
////                dday: "D-10"
////            )
////        ]
////    }
////}
//#endif
