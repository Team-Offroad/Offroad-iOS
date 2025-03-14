//
//  StringLiterals.swift
//  Offroad-iOS
//
//  Created by 김민성 on 11/19/24.
//

struct ErrorMessages {
    static let networkError = "네트워크 연결 상태를 확인해주세요."
    static let versionError = "최신 버전으로 업데이트해주세요." // 임의 작성. 기획과 논의 필요
    static let locationUnauthorized = "위치 정보 사용 동의 후 이용 가능합니다."
    static let cameraUsageUnauthorized = "카메라 권한 허용 후 이용 가능합니다."
    static let birthDateError = "다시 한 번 확인해주세요."
    static let getCharacterListFailure = "캐릭터 목록을 불러오는 데 실패하였습니다."
    static let accessingLocationDataFailure = "위치 정보를 가져오는 데 실패했습니다."
}

struct AlertMessage {
    static let adventureSuccessTitle = "탐험 성공"
    static let adventureSuccessMessage = "탐험에 성공했어요!\n이곳에 무엇이 있는지 천천히 살펴볼까요?"
    static let adventureFailureTitle = "탐험 실패"
    static let adventureFailureLocationMessage = "탐험에 실패했어요.\n위치를 다시 한 번 확인해주세요."
    static let adventureFailureQRMessage = "탐험에 실패했어요.\nQR코드를 다시 한 번 확인해주세요."
    static let adventureFailureVisitCountMessage = "한 장소는 하루에 한 번만 방문 가능해요.\n내일 다시 방문해주세요."
    static let couponRedemptionSuccessTitle = "사용 완료"
    static let couponRedemptionSuccessMessage = "쿠폰 사용이 완료되었어요!"
    static let couponRedemptionFailureTitle = "사용 실패"
    static let couponRedemptionFailureMessage = "다시 한 번 확인해 주세요."
    static let locationUnauthorizedTitle = "위치 서비스 설정"
    static let locationUnauthorizedMessage = "위치 확인을 위해서는 설정에서 위치 접근을 허용해 주세요."
    static let locationUnauthorizedAdventureMessage = "위치정보 사용 동의 후 이용 가능합니다."
    static let locationServicesDisabledMessage = "모험가님의 위치를 찾을 수 없어요.\n탐험을 위해서 위치 기능을 활성화해주세요."
    static let locationReducedAccuracyMessage = "모험가님의 정확한 위치를 찾을 수 없어요.\n탐험을 위해서 정확한 위치 접근 권한을 허용해주세요."
    static let completeQuestsTitle = "퀘스트 성공 !"
    static let diaryTimeSettingMessage = "매일 이 시간에 일기를 받으시겠어요?"
    static let diaryTimeUnsavedExitMessage = "일기 시간 설정을 저장하지 않고\n나가시겠어요?"
    static let diaryTimeGuideTitle = "오후 10시"
    static let diaryTimeGuideMessage = "오브와 충분한 시간을 함께하면\n매일 오후 10시에 일기를 받아요.\n\n설정 에서 일기 받을 시간을 바꿀 수 있어요."
    static func completeSingleQuestMessage(questName: String) -> String {
        "퀘스트 '\(questName)'을(를) 클리어했어요! 마이페이지에서 보상을 확인해보세요."
    }
    static func completeMultipleQuestsMessage(firstQuestName: String, questCount: Int) -> String {
        "퀘스트 '\(firstQuestName)' 외 \(questCount - 1)개를 클리어했어요! 마이페이지에서 보상을 확인해보세요."
    }
    static func diaryTimeSettinTitle(selectedTimePeriod: TimePeriod, selectedTime: Int) -> String {
        "\(selectedTimePeriod == .am ? "오전" : "오후") \(selectedTime)시"
    }
}

struct LoadingMessage {
    static let loading = "로딩 중입니다."
    /// 현재 로직 상 사용할 일 없음. (퀘스트 클리어 팝업은 로딩 없이 바로 띄우기 때문)
    static let questClearing = "클리어한 퀘스트가 있어요. 잠시만 기다려주세요."
    static let login = "로그인 중입니다."
}

struct EmptyCaseMessage {
    static let unvisitedPlaceList = "대단해요! 근처에 있는 곳은 모두 탐험했어요.\n다른 곳을 둘러보세요!"
    static let placeList = "근처에 탐험할 수 있는 장소가 없어요."
    static let availableCoupons = "사용 가능한 쿠폰이 없어요.\n퀘스트를 클리어하고 쿠폰을 획득해 보세요!"
    static let usedCoupons = "사용 완료한 쿠폰이 없어요.\n획득한 쿠폰을 사용해 보세요!"
    static let activeQuests = "진행 중인 퀘스트가 없어요.\n탐험을 시작하고 퀘스트를 클리어해 보세요!"
}

struct DiaryGuideMessage {
    static let diaryGuideDescription1 = "오브와 대화를 나누거나\n함께 탐험을 떠나면,\n매일 기록을 모아 오브가 일기를 써요.\n\n일기를 받기 위해선\n오브와 충분한 시간을 보내야해요."
    static let diaryGuideDescription2 = "이건 기억빛이에요.\n\n그 날의 기억에 따라\n다른 색으로 칠해져요.\n오늘은 어떤 색의 하루였나요?"
}

struct AmplitudeEventTitles {
    static let questSuccess = "quest_success"
    static let chatMessageSent = "send_chat"
    static let exploreSuccess = "explore_success"
}
