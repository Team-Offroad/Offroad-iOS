//
//  MemoryLightModel.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 3/20/25.
//

struct MemoryLightModel {
    let id: Int
    let dailyRecommend: String
    let content: String
    let year: Int
    let month: Int
    let day: Int
    let summation: String
    let hexCodes: [MemoryLightColorModel]
}

struct MemoryLightColorModel {
    let small: String
    let large: String
}

extension MemoryLightModel {
    static func dummy() -> [MemoryLightModel] {
        return [
            MemoryLightModel(
                id: 1,
                dailyRecommend: "추천 text",
                content: "그리고 오늘의 기억을 오늘 하루동안 나눈 대화, 방문한 장소, 시간 데이터를 바탕으로 요약합니다. 이때 단순 요약이 아니라 AI가 남기는 일종의 메시지 형태라고 보시면 될 것 같고 앞으로에 대한 기대, 응원, 위로 등의 내용이 담겨 있습니다. 앞으로에 대한 기대, 응원, 위로 등의 내용이 담겨 있습니다. 내용이 담겨 있습니다. 앞으로에 대한 기대, 응원, 위로 등의 내용이 담겨 있습니다.",
                year: 2025,
                month: 3,
                day: 7,
                summation: "오늘의 기억을 AI가 한 줄로 요약합니다.오늘의 기억을 AI가 한 줄로 요약합니다.",
                hexCodes: [MemoryLightColorModel(small: "70DAFFB2", large: "FFDC14B2")]
            ),
            MemoryLightModel(
                id: 2,
                dailyRecommend: "추천 text",
                content: "그리고 오늘의 기억을 오늘 하루동안 나눈 대화, 방문한 장소, 시간 데이터를 바탕으로 요약합니다. 이때 단순 요약이 아니라 AI가 남기는 일종의 메시지 형태라고 보시면 될 것 같고 앞으로에 대한 기대, 응원, 위로 등의 내용이 담겨 있습니다. 앞으로에 대한 기대, 응원, 위로 등의 내용이 담겨 있습니다. 내용이 담겨 있습니다. 앞으로에 대한 기대, 응원, 위로 등의 내용이 담겨 있습니다.",
                year: 2025,
                month: 3,
                day: 8,
                summation: "오늘의 기억을 AI가 한 줄로 요약합니다.오늘의 기억을 AI가 한 줄로 요약합니다.",
                hexCodes: [MemoryLightColorModel(small: "FF69E1B2", large: "FFB73BB2")]
            ),
            MemoryLightModel(
                id: 3,
                dailyRecommend: "추천 text",
                content: "그리고 오늘의 기억을 오늘 하루동안 나눈 대화, 방문한 장소, 시간 데이터를 바탕으로 요약합니다.",
                year: 2025,
                month: 3,
                day: 14,
                summation: "오늘의 기억을 AI가 한 줄로 요약합니다.",
                hexCodes: [MemoryLightColorModel(small: "FFAF40B2", large: "FF8DABB2")]
            ),
            MemoryLightModel(
                id: 4,
                dailyRecommend: "추천 text",
                content: "그리고 오늘의 기억을 오늘 하루동안 나눈 대화, 방문한 장소, 시간 데이터를 바탕으로 요약합니다. 이때 단순 요약이 아니라 AI가 남기는 일종의 메시지 형태라고 보시면 될 것 같고 앞으로에 대한 기대, 응원, 위로 등의 내용이 담겨 있습니다. 앞으로에 대한 기대, 응원, 위로 등의 내용이 담겨 있습니다. 내용이 담겨 있습니다. 앞으로에 대한 기대, 응원, 위로 등의 내용이 담겨 있습니다.",
                year: 2025,
                month: 3,
                day: 10,
                summation: "오늘의 기억을 AI가 한 줄로 요약합니다.오늘의 기억을 AI가 한 줄로 요약합니다.",
                hexCodes: [MemoryLightColorModel(small: "FF69E1B2", large: "5580FFB2")]
            ),
            MemoryLightModel(
                id: 5,
                dailyRecommend: "추천 text",
                content: "그리고 오늘의 기억을 오늘 하루동안 나눈 대화, 방문한 장소, 시간 데이터를 바탕으로 요약합니다. 이때 단순 요약이 아니라 AI가 남기는 일종의 메시지 형태라고 보시면 될 것 같고 앞으로에 대한 기대, 응원, 위로 등의 내용이 담겨 있습니다. 앞으로에 대한 기대, 응원, 위로 등의 내용이 담겨 있습니다. 내용이 담겨 있습니다. 앞으로에 대한 기대, 응원, 위로 등의 내용이 담겨 있습니다.",
                year: 2025,
                month: 3,
                day: 19,
                summation: "오늘의 기억을 AI가 한 줄로 요약",
                hexCodes: [MemoryLightColorModel(small: "FFAF40B2", large: "FF8DABB2")]
            ),
            MemoryLightModel(
                id: 6,
                dailyRecommend: "추천 text",
                content: "그리고 오늘의 기억을 오늘 하루동안 나눈 대화, 방문한 장소",
                year: 2025,
                month: 3,
                day: 20,
                summation: "오늘의 기억을 AI가 한 줄로 요약합니다.오늘의 기억을 AI가 한 줄로 요약합니다.",
                hexCodes: [MemoryLightColorModel(small: "FFAF40B2", large: "FF8DABB2")]
            )
        ]
    }
}
