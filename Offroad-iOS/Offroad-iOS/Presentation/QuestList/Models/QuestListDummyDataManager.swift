//
//  QuestListDummyDataManager.swift
//  Offroad-iOS
//
//  Created by 김민성 on 8/10/24.
//

import Foundation

// 더미데이터 입니다.
// 서버 API가 나올 경우 이에 맞게 변경하여 사용하길 바랍니다.
struct QuestDTO {
    
    let title: String
    let questDescription: String
    let questClearDescription: String
    let questRewardDescription: String
    let totalProcess: Int
    let process: Int
    
}

class QuestListDummyDataManager {
    
    func makeDummyData() -> [QuestDTO] {
        
        return Array<QuestDTO>.init(
            arrayLiteral:
                dummyQuest01,
            dummyQuest02,
            dummyQuest03,
            dummyQuest04,
            dummyQuest05,
            dummyQuest06,
            dummyQuest07,
            dummyQuest08,
            dummyQuest09,
            dummyQuest10,
            dummyQuest11,
            dummyQuest12,
            dummyQuest13,
            dummyQuest14,
            dummyQuest15,
            dummyQuest16,
            dummyQuest17,
            dummyQuest18,
            dummyQuest19,
            dummyQuest20,
            dummyQuest21,
            dummyQuest22,
            dummyQuest23,
            dummyQuest24
        )
    }
    
    let dummyQuest01 = QuestDTO(
        title: "오프로드로 가는 길",
        questDescription: "이것은 퀘스트 상세 정보 문구입니다. 이 문구를 읽고 있다는 것은 매우 자세히 보고 있다는 뜻이겠죠? 너무 뚫어지게 쳐다보면 핸드폰 화면이 뚫릴 수 있으니 주의해주세요! 그럼 오늘도 행복코딩!!",
        questClearDescription: "오프로드 회원가입 & 캐릭터 선택 후 홈 첫 진입 시",
        questRewardDescription: "칭호: 오프로드 스타터",
        totalProcess: 1,
        process: 0
    )
    
    let dummyQuest02 = QuestDTO(
        title: "탐험! 오프로드(1)",
        questDescription: "이것은 퀘스트 상세 정보 문구입니다. 이 문구를 읽고 있다는 것은 매우 자세히 보고 있다는 뜻이겠죠? 너무 뚫어지게 쳐다보면 핸드폰 화면이 뚫릴 수 있으니 주의해주세요! 그럼 오늘도 행복코딩!!",
        questClearDescription: "첫 탐험을 성공하였을 시",
        questRewardDescription: "칭호: 위대한 첫 걸음",
        totalProcess: 1,
        process: 0
    )
    
    let dummyQuest03 = QuestDTO(
        title: "탐험! 오프로드(2)",
        questDescription: "너무 무리하면 건강을 잃을 수도 있습니다. 건강이 있어야 작업이 있는 법이겠지요? 만약 이 글을 뚫어지게 쳐다보고 있다면 이 기회에 허리를 펴고 올바를 자세를 잡아보도록 해요! 그럼 오늘도 행복코딩!!",
        questClearDescription: "탐험 3개를 성공했을 시",
        questRewardDescription: "칭호: 왕초보 탐험가",
        totalProcess: 3,
        process: 2
    )
    
    let dummyQuest04 = QuestDTO(
        title: "탐험! 오프로드(3)",
        questDescription: "이것은 퀘스트 상세 정보 문구입니다. 이 문구를 읽고 있다는 것은 매우 자세히 보고 있다는 뜻이겠죠? 너무 뚫어지게 쳐다보면 핸드폰 화면이 뚫릴 수 있으니 주의해주세요! 그럼 오늘도 행복코딩!!",
        questClearDescription: "탐험 10개를 성공했을 시",
        questRewardDescription: "칭호: 초보 탐험가",
        totalProcess: 10,
        process: 10
    )
    
    let dummyQuest05 = QuestDTO(
        title: "탐험! 오프로드(4)",
        questDescription: "바빠서 개발 할 시간이 없는 점이 너무 슬프네요..빠르게 제 일정이 정상화되어 오프로드에 기여할 수 있길 바랍니다! 그럼 오늘도 행복코딩!!",
        questClearDescription: "탐험 50개를 성공했을 시",
        questRewardDescription: "칭호: 베테랑 탐험가",
        totalProcess: 50,
        process: 10
    )
    
    let dummyQuest06 = QuestDTO(
        title: "탐험! 오프로드",
        questDescription: "너무 무리하면 건강을 잃을 수도 있습니다. 건강이 있어야 작업이 있는 법이겠지요? 만약 이 글을 뚫어지게 쳐다보고 있다면 이 기회에 허리를 펴고 올바를 자세를 잡아보도록 해요! 그럼 오늘도 행복코딩!!",
        questClearDescription: "탐험 100개를 성공했을 시",
        questRewardDescription: "칭호: 탐험 전문가",
        totalProcess: 100,
        process: 25
    )
    
    let dummyQuest07 = QuestDTO(
        title: "탐험! 오프로드(5)",
        questDescription: "이것은 퀘스트 상세 정보 문구입니다. 이 문구를 읽고 있다는 것은 매우 자세히 보고 있다는 뜻이겠죠? 너무 뚫어지게 쳐다보면 핸드폰 화면이 뚫릴 수 있으니 주의해주세요! 그럼 오늘도 행복코딩!!",
        questClearDescription: "탐험 300개를 성공했을 시",
        questRewardDescription: "칭호: 탐험의 정수",
        totalProcess: 300,
        process: 13
    )
    
    let dummyQuest08 = QuestDTO(
        title: "탐험! 오프로드(7)",
        questDescription: "바빠서 개발 할 시간이 없는 점이 너무 슬프네요..빠르게 제 일정이 정상화되어 오프로드에 기여할 수 있길 바랍니다! 그럼 오늘도 행복코딩!!",
        questClearDescription: "탐험 500개를 성공했을 시",
        questRewardDescription: "칭호: 탐험 챔피언",
        totalProcess: 500,
        process: 150
    )
    
    let dummyQuest09 = QuestDTO(
        title: "탐험! 오프로드(8)",
        questDescription: "이것은 퀘스트 상세 정보 문구입니다. 이 문구를 읽고 있다는 것은 매우 자세히 보고 있다는 뜻이겠죠? 너무 뚫어지게 쳐다보면 핸드폰 화면이 뚫릴 수 있으니 주의해주세요! 그럼 오늘도 행복코딩!!",
        questClearDescription: "탐험 1000개를 성공했을 시",
        questRewardDescription: "칭호: 탐험의 전설",
        totalProcess: 1000,
        process: 34
    )
    
    let dummyQuest10 = QuestDTO(
        title: "탐험! 오프로드(9)",
        questDescription: "이것은 퀘스트 상세 정보 문구입니다. 이 문구를 읽고 있다는 것은 매우 자세히 보고 있다는 뜻이겠죠? 너무 뚫어지게 쳐다보면 핸드폰 화면이 뚫릴 수 있으니 주의해주세요! 그럼 오늘도 행복코딩!!",
        questClearDescription: "탐험 5000개를 성공했을 시",
        questRewardDescription: "칭호: 탐험의 신",
        totalProcess: 5000,
        process: 1021
    )
    
    let dummyQuest11 = QuestDTO(
        title: "공원 탐험(1)",
        questDescription: "너무 무리하면 건강을 잃을 수도 있습니다. 건강이 있어야 작업이 있는 법이겠지요? 만약 이 글을 뚫어지게 쳐다보고 있다면 이 기회에 허리를 펴고 올바를 자세를 잡아보도록 해요! 그럼 오늘도 행복코딩!!",
        questClearDescription: "첫 공원 방문 시",
        questRewardDescription: "모션: 걷는 모션(산책하는 모션)",
        totalProcess: 1,
        process: 1
    )
    
    let dummyQuest12 = QuestDTO(
        title: "공원 탐험(2)",
        questDescription: "바빠서 개발 할 시간이 없는 점이 너무 슬프네요..빠르게 제 일정이 정상화되어 오프로드에 기여할 수 있길 바랍니다! 그럼 오늘도 행복코딩!!",
        questClearDescription: "공원 10번 방문 시",
        questRewardDescription: "칭호: 산책 마니아",
        totalProcess: 10,
        process: 6
    )
    
    let dummyQuest13 = QuestDTO(
        title: "공원 탐험(3)",
        questDescription: "이것은 퀘스트 상세 정보 문구입니다. 이 문구를 읽고 있다는 것은 매우 자세히 보고 있다는 뜻이겠죠? 너무 뚫어지게 쳐다보면 핸드폰 화면이 뚫릴 수 있으니 주의해주세요! 그럼 오늘도 행복코딩!!",
        questClearDescription: "공원 50번 방문 시",
        questRewardDescription: "칭호: 모르는 개 산책 (모션: 강아지와 산책하는 모션)",
        totalProcess: 50,
        process: 10
    )
    
    let dummyQuest14 = QuestDTO(
        title: "식당 탐험(1)",
        questDescription: "바빠서 개발 할 시간이 없는 점이 너무 슬프네요..빠르게 제 일정이 정상화되어 오프로드에 기여할 수 있길 바랍니다! 그럼 오늘도 행복코딩!!",
        questClearDescription: "첫 식당 방문 시",
        questRewardDescription: "모션: 밥 먹는 모션",
        totalProcess: 1,
        process: 0
    )
    
    let dummyQuest15 = QuestDTO(
        title: "식당 탐험(2)",
        questDescription: "너무 무리하면 건강을 잃을 수도 있습니다. 건강이 있어야 작업이 있는 법이겠지요? 만약 이 글을 뚫어지게 쳐다보고 있다면 이 기회에 허리를 펴고 올바를 자세를 잡아보도록 해요! 그럼 오늘도 행복코딩!!",
        questClearDescription: "식당 10번 방문 시",
        questRewardDescription: "칭호: 맛집 헌터, 쿠폰: 식당 10% 할인",
        totalProcess: 10,
        process: 10
    )
    
    let dummyQuest16 = QuestDTO(
        title: "식당 탐험(3)",
        questDescription: "이것은 퀘스트 상세 정보 문구입니다. 이 문구를 읽고 있다는 것은 매우 자세히 보고 있다는 뜻이겠죠? 너무 뚫어지게 쳐다보면 핸드폰 화면이 뚫릴 수 있으니 주의해주세요! 그럼 오늘도 행복코딩!!",
        questClearDescription: "식당 50번 방문 시",
        questRewardDescription: "칭호: 너와 100번째 식당, 쿠폰: 식당 20만원권",
        totalProcess: 50,
        process: 13
    )
    
    let dummyQuest17 = QuestDTO(
        title: "카페 탐험(1)",
        questDescription: "이것은 퀘스트 상세 정보 문구입니다. 이 문구를 읽고 있다는 것은 매우 자세히 보고 있다는 뜻이겠죠? 너무 뚫어지게 쳐다보면 핸드폰 화면이 뚫릴 수 있으니 주의해주세요! 그럼 오늘도 행복코딩!!",
        questClearDescription: "첫 카페 방문 시",
        questRewardDescription: "모션: 커피 마시는 모션",
        totalProcess: 1,
        process: 1
    )
    
    let dummyQuest18 = QuestDTO(
        title: "카페 탐험(2)",
        questDescription: "너무 무리하면 건강을 잃을 수도 있습니다. 건강이 있어야 작업이 있는 법이겠지요? 만약 이 글을 뚫어지게 쳐다보고 있다면 이 기회에 허리를 펴고 올바를 자세를 잡아보도록 해요! 그럼 오늘도 행복코딩!!",
        questClearDescription: "카페 10번 방문 시",
        questRewardDescription: "칭호: 카페는 내 친구, 쿠폰: 카페 10% 할인",
        totalProcess: 10,
        process: 10
    )
    
    let dummyQuest19 = QuestDTO(
        title: "카페 탐험(3)",
        questDescription: "이것은 퀘스트 상세 정보 문구입니다. 이 문구를 읽고 있다는 것은 매우 자세히 보고 있다는 뜻이겠죠? 너무 뚫어지게 쳐다보면 핸드폰 화면이 뚫릴 수 있으니 주의해주세요! 그럼 오늘도 행복코딩!!",
        questClearDescription: "카페 50번 방문 시",
        questRewardDescription: "칭호: 카페 중독, 쿠폰: 카페 10만원권",
        totalProcess: 50,
        process: 11
    )
    
    let dummyQuest20 = QuestDTO(
        title: "카페 탐험(4)",
        questDescription: "이것은 퀘스트 상세 정보 문구입니다. 이 문구를 읽고 있다는 것은 매우 자세히 보고 있다는 뜻이겠죠? 너무 뚫어지게 쳐다보면 핸드폰 화면이 뚫릴 수 있으니 주의해주세요! 그럼 오늘도 행복코딩!!",
        questClearDescription: "카페 200번 방문 시",
        questRewardDescription: "칭호: 커피바라, 모션: 카피바라와 함께 커피를 마심",
        totalProcess: 200,
        process: 101
    )
    
    let dummyQuest21 = QuestDTO(
        title: "스포츠 탐험(1)",
        questDescription: "너무 무리하면 건강을 잃을 수도 있습니다. 건강이 있어야 작업이 있는 법이겠지요? 만약 이 글을 뚫어지게 쳐다보고 있다면 이 기회에 허리를 펴고 올바를 자세를 잡아보도록 해요! 그럼 오늘도 행복코딩!!",
        questClearDescription: "첫 스포츠 카테고리 방문 시",
        questRewardDescription: "모션: 운동을 하는 모션",
        totalProcess: 1,
        process: 0
    )
    
    let dummyQuest22 = QuestDTO(
        title: "스포츠 탐험(2)",
        questDescription: "이것은 퀘스트 상세 정보 문구입니다. 이 문구를 읽고 있다는 것은 매우 자세히 보고 있다는 뜻이겠죠? 너무 뚫어지게 쳐다보면 핸드폰 화면이 뚫릴 수 있으니 주의해주세요! 그럼 오늘도 행복코딩!!",
        questClearDescription: "스포츠 카테고리 15번 방문 시",
        questRewardDescription: "칭호: 경기장의 휘슬 소리",
        totalProcess: 15,
        process: 3
    )
    
    let dummyQuest23 = QuestDTO(
        title: "문화 탐험(1)",
        questDescription: "바빠서 개발 할 시간이 없는 점이 너무 슬프네요..빠르게 제 일정이 정상화되어 오프로드에 기여할 수 있길 바랍니다! 그럼 오늘도 행복코딩!!",
        questClearDescription: "첫 문화 카테고리 방문 시",
        questRewardDescription: "모션: 전시를 구경하는 모션",
        totalProcess: 1,
        process: 0
    )
    
    let dummyQuest24 = QuestDTO(
        title: "문화 탐험(2)",
        questDescription: "이것은 퀘스트 상세 정보 문구입니다. 이 문구를 읽고 있다는 것은 매우 자세히 보고 있다는 뜻이겠죠? 너무 뚫어지게 쳐다보면 핸드폰 화면이 뚫릴 수 있으니 주의해주세요! 그럼 오늘도 행복코딩!!",
        questClearDescription: "문화 카테고리 15번 방문 시",
        questRewardDescription: "칭호: 문화 생활",
        totalProcess: 15,
        process: 7
    )
    
}
