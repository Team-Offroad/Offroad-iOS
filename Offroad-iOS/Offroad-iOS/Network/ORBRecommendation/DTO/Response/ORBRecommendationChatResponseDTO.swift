//
//  ORBRecommendationChatResponseDTO.swift
//  ORB
//
//  Created by 김민성 on 6/7/25.
//

struct ORBRecommendationChatResponseDTO: Decodable {
    let message: String
    let data: ORBRecommendationChatResponseData
}

struct ORBRecommendationChatResponseData: Decodable {
    let content: String
    let success: Bool
}
