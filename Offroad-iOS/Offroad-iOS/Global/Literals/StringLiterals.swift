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
    static let appStoreRedirectionFailure = "앱스토어를 열 수 없어요.\n앱 설치 가능 여부를 확인해 주세요"
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
    static let orbRecommendationOrderUnsavedExitMessage = "주문 내용이 저장되지 않아요.\n작성을 멈추고 나가시겠어요?"
    static let enforceAppUpdateTitle = "업데이트 안내"
    static let enforceAppUpdateMessage = "오브의 공간에 변화가 생겼어요!\n앱을 최신 버전으로 업데이트 해주세요."
    static let courseQuestFailureLocationTitle = "방문 실패"
    static let courseQuestFailureLocationMessage = "거리가 너무 멀어요.\n더 가까이에서 방문 버튼을 눌러주세요."
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

struct DiaryMessage {
    static let diaryEmptyDesription = "만들어진 일기가 없어요.\n\n오브가 아직 어색한가 봐요.\n조금 더 대화를 나눠보세요."
    static let completeCreateDiaryTitle = "일기 완성!"
    static let completeCreateDiaryMessage = "오늘의 일기가 완성되었어요.\n기억빛과 함께 하루를 돌아보세요."
}

struct AmplitudeEventTitles {
    static let questSuccess = "quest_success"
    static let chatMessageSent = "send_chat"
    static let exploreSuccess = "explore_success"
}

struct ORBRecommendationOrderText {
    static let title = "추천 주문서"
    static let question1 = "어떤 추천이 필요하신가요? *"
    static let answer1RequiredMessage = "*필수 체크 사항입니다."
    static let question2 = "어느 지역으로 추천해 드릴까요? *"
    static let answer2Placeholder = "방문하실 지역을 입력하세요."
    static let answer2RequiredMessage = "*필수 입력 사항입니다."
    static let question3 = "추가로 원하시는 내용이 있다면 입력해주세요."
    static let answer3Placeholder = "기분이 안 좋은데 스트레스 풀릴만한 음식 추천해줘. 애인과 함께할 분위기 좋은 식당이면 좋겠어."
}

/// 오브의 추천소의 답변 메시지. 서버에서 추천 로직 자체는 성공했으나, 추천 장소 목록이 비어있을 경우에 대한 답변
struct ORBRecommendationChatPlacesNotFoundText {
    static let text1 = "으앙… 딱 맞는 곳이 안 보여😣\n다른 말로 한 번 더 알려줄래? 다시 찾아볼게 츄츄!"
    static let text2 = "괜찮은 장소를 못 찾았어😢\n지역이나 내용을 조금 바꿔보지 않을래 츄츄?"
    static let text3 = "우움 지금은 딱 떠오르는 데가 없네\n기분이나 상황을 조금만 더 알려주라 츄츄🎶"
    static let text4 = "미안해… 추천할 장소를 못 찾았어💦\n혹시 다른 조건으로 찾아보는건 어때 츄츄?"
    static let text5 = "마땅한 장소를 못 찾았어 미안해애…\n지역이나 원하는 내용을 다시 정해주라 츄츄😢"

    static let textList: [String] = [text1, text2, text3, text4, text5]
}
