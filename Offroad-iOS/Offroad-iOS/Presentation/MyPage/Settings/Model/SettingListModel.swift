//
//  SettingListModel.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 8/7/24.
//

struct SettingListModel {
    let listString: String
}

extension SettingListModel {
    static func dummy() -> [SettingListModel] {
        return [
            SettingListModel(listString: "공지사항"),
            SettingListModel(listString: "플레이 가이드"),
            SettingListModel(listString: "서비스 이용약관"),
            SettingListModel(listString: "개인정보처리방침"),
            SettingListModel(listString: "마케팅 수신동의"),
            SettingListModel(listString: "로그아웃"),
            SettingListModel(listString: "회원 탈퇴")
        ]
    }
}
