//
//  ORBRecommendationFixedPhraseResponseDTO.swift
//  ORB_Dev
//
//  Created by 김민성 on 6/19/25.
//

struct ORBRecommendationFixedPhraseResponseDTO: Decodable {
    let message: String
    let data: ORBRecommendationFixedPhraseResponseData
}

struct ORBRecommendationFixedPhraseResponseData: Decodable {
    let content: String
}
