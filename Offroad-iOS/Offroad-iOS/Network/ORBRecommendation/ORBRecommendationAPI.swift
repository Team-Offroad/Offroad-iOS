//
//  ORBRecommendationAPI.swift
//  Offroad-iOS
//
//  Created by 김민성 on 6/7/25.
//

import Foundation

import Moya

enum ORBRecommendationAPI: BaseTargetType {
    /// 오브의 추천소 메인화면 상단 고정 문구 요청(`GET`)
    case getFixedPhrase
    case getRecommendedPlaces
    case postRecommendationChat(content: String)
}

extension ORBRecommendationAPI {
    var headerType: HeaderType {
        return .accessTokenHeaderForGet
    }
    
    var path: String {
        switch self {
        case .getFixedPhrase:
            return "/place-recommendations/fixed-phrase"
        case .getRecommendedPlaces:
            return "/place-recommendations"
        case .postRecommendationChat:
            return "/place-recommendations/order/chat"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getFixedPhrase, .getRecommendedPlaces:
            return .get
        case .postRecommendationChat:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getFixedPhrase, .getRecommendedPlaces:
            return .requestPlain
        case .postRecommendationChat(let content):
            let requestDTO = ORBREcommendationChatRequestDTO(content: content)
            return .requestJSONEncodable(requestDTO)
        }
    }
}
