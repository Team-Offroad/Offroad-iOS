//
//  SettingBaseModel.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 8/7/24.
//

struct SettingBaseModel {
    let listString: String
}

extension SettingBaseModel {
    
    #if DevTarget
    static let settingListModel: [SettingBaseModel] = [
        SettingBaseModel(listString: "공지사항"),
        SettingBaseModel(listString: "일기 시간"),
        SettingBaseModel(listString: "플레이 가이드"),
        SettingBaseModel(listString: "서비스 이용약관"),
        SettingBaseModel(listString: "개인정보처리방침"),
        SettingBaseModel(listString: "마케팅 수신동의"),
        SettingBaseModel(listString: "고객 문의"),
        SettingBaseModel(listString: "로그아웃"),
        SettingBaseModel(listString: "회원 탈퇴"),
        SettingBaseModel(listString: "개발자 모드")
    ]
    #else
    static let settingListModel: [SettingBaseModel] = [
        SettingBaseModel(listString: "공지사항"),
        SettingBaseModel(listString: "일기 시간"),
        SettingBaseModel(listString: "플레이 가이드"),
        SettingBaseModel(listString: "서비스 이용약관"),
        SettingBaseModel(listString: "개인정보처리방침"),
        SettingBaseModel(listString: "마케팅 수신동의"),
        SettingBaseModel(listString: "고객 문의"),
        SettingBaseModel(listString: "로그아웃"),
        SettingBaseModel(listString: "회원 탈퇴")
    ]
    #endif
    
    static let settingNoticeModel: [SettingBaseModel] = [
        SettingBaseModel(listString: "[중요] 오프로드가 여러분의 의견을 듣습니다."),
        SettingBaseModel(listString: "[중요] 저는 락이 좋아요"),
        SettingBaseModel(listString: "제휴 업체 안내"),
        SettingBaseModel(listString: "운영 관련 안내"),
        SettingBaseModel(listString: "이벤트 관련 안내"),
        SettingBaseModel(listString: "오프로드 고객센터 추석 휴무 안내"),
        SettingBaseModel(listString: "운영 관련 사항을 알려드립니다.")
    ]
    
}

