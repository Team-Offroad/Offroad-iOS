//
//  NoticePostModel.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 8/16/24.
//

struct NoticePostModel {
    let dateString: String
    let titleString: String
    let contentString: String
    let contentButtonString: String
}

extension NoticePostModel {
    static let noticePostModel = NoticePostModel(
        dateString: "2024 / 07 / 31",
        titleString: "[중요] 오프로드가 여러분의 의견을 듣습니다.",
        contentString: """
소중한 오프로드 유저 여러분, 안녕하세요!

오프로드가 여러분들의 의견에 보다 귀 기울이기 위해 정기 설문조사를 실시합니다.

오프로드가 발전해 나가는데 큰 도움이 됩니다.

마감기한은 2024년 8월 30일이며 설문조사 참여는
참여 인원에 따라 선착순 종료될 수 있습니다.
""",
        contentButtonString: "설문조사 바로가기 CLICK !"
    )
}
