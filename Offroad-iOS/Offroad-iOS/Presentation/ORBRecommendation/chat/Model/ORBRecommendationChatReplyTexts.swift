//
//  ORBRecommendationChatReplyTexts.swift
//  ORB_Dev
//
//  Created by 김민성 on 6/25/25.
//

/// 오브의 추천소에서 랜덤으로 보여질 텍스트를 생성하는 텍스트 랜던 생성기.
///
/// - Note: 원래는 서버의 로직이지만, 임시로 클라이언트에서 구현.
/// 서버에서 추천 로직 자체는 성공했으나, 추천 장소 목록이 비어있을 경우에 대한 답변만을 생성.
struct ORBRecommendationTextGenerator {
    
    static func getRandomText() -> String {
        ORBRecommendationChatPlacesNotFoundText.textList.randomElement()!
    }
    
}
