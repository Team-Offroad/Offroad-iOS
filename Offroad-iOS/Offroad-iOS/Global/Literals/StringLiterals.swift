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
}

struct LoadingMessage {
    static let loading = "로딩 중입니다."
    /// 현재 로직 상 사용할 일 없음. (퀘스트 클리어 팝업은 로딩 없이 바로 띄우기 때문)
    static let questClearing = "클리어한 퀘스트가 있어요. 잠시마 기다려주세요."
    static let login = "로그인 중입니다."
}

struct EmptyCaseMessage {
    static let unvisitedPlaces = "대단해요! 근처에 있는 곳은 모두 탐험했어요.\n다른 곳을 둘러보세요!"
    static let vistedPlaces = "근처에 탐험할 수 있는 장소가 없어요."
    static let availableCoupons = "사용 가능한 쿠폰이 없어요.\n퀘스트를 클리어하고 쿠폰을 획득해 보세요!"
    static let usedCoupons = "사용 완료한 쿠폰이 없어요.\n획득한 쿠폰을 사용해 보세요!"
    static let activeQuests = "진행 중인 퀘스트가 없어요.\n탐험을 시작하고 퀘스트를 클리어해 보세요!"
}
