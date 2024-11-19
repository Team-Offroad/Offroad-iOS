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
}


struct AlertMessage {
    static let adventureSuccessTitle = "탐험 성공"
    static let adventureSuccessMessage = "탐험에 성공했어요!\n이곳에 무엇이 있는지 천천히 살펴볼까요?"
    static let adventureFailureTitle = "탐험 실패"
    static let adventureFailureLocationMessage = "탐험에 실패했어요.\n위치를 다시 한 번 확인해주세요."
    static let adventureFailureQRMessage = "탐험에 실패했어요.\nQR코드를 다시 한 번 확인해주세요."
}

struct LoadingMesage {
    static let loading = "로딩 중입니다."
    /// 현재 로직 상 사용할 일 없음. (퀘스트 클리어 팝업은 로딩 없이 바로 띄우기 때문)
    static let questClearing = "클리어한 퀘스트가 있어요. 잠시마 기다려주세요."
    static let login = "로그인 중입니다."
}
