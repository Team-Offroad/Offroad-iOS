//
//  CollectedTitleModel.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 8/5/24.
//

struct CollectedTitleModel {
    let titleString: String
    let collectConditionString: String
    let isCollected: Bool
}

extension CollectedTitleModel {
    static func dummy() -> [CollectedTitleModel] {
        return [
            CollectedTitleModel(titleString: "상수 고수 악수 박수", collectConditionString: "'지역별로 탐험하자(8)'", isCollected: true),
            CollectedTitleModel(titleString: "상수 고수 악수 박수1", collectConditionString: "'지역별로 탐험하자(8)!'", isCollected: true),
            CollectedTitleModel(titleString: "상수 고수 악수 박수2", collectConditionString: "'지역별로 탐험하자(8)'~", isCollected: false),
            CollectedTitleModel(titleString: "상수 고수 악수 박수3", collectConditionString: "'지역별로 탐험하자(8)'$ff", isCollected: true),
            CollectedTitleModel(titleString: "상수 고수 악수 박수4", collectConditionString: "'지역별로 탐험하자(8)'d", isCollected: true),
            CollectedTitleModel(titleString: "상수 고수 악수 박수5", collectConditionString: "'지역별로 탐험하자(8)'ㅎㅎ", isCollected: true),
            CollectedTitleModel(titleString: "상수 고수 악수 박수6", collectConditionString: "'지역별로 탐험하자(8)'ㅋ", isCollected: false),
            CollectedTitleModel(titleString: "상수 고수 악수 박수7", collectConditionString: "'지역별로 탐험하자(8)ㄹ'", isCollected: false),
            CollectedTitleModel(titleString: "상수 고수 악수 박수8", collectConditionString: "'지역별로 탐험하자(8)'^^", isCollected: true)
        ]
    }
}
