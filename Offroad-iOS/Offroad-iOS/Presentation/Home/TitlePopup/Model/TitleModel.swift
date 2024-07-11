//
//  TitleModel.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 7/12/24.
//

struct TitleModel {
    let titleString: String
}

extension TitleModel {
    static func dummy() -> [TitleModel] {
        return [
            TitleModel(titleString: "오프로드 스타터"),
            TitleModel(titleString: "위대한 첫 걸음"),
            TitleModel(titleString: "왕초보 탐험가"),
            TitleModel(titleString: "초보 탐험가"),
            TitleModel(titleString: "맛집 헌터"),
            TitleModel(titleString: "카페는 내 친구")
        ]
    }
}
