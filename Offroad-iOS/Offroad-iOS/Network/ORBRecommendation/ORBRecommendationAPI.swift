//
//  ORBRecommendationAPI.swift
//  Offroad-iOS
//
//  Created by 김민성 on 6/7/25.
//

import Foundation

import Moya

enum ORBRecommendationAPI: BaseTargetType {
    case getRecommendedPlaces
    case postRecommendationChat(content: String)
}

extension ORBRecommendationAPI {
    var headerType: HeaderType {
        return .accessTokenHeaderForGet
    }
    
    var path: String {
        switch self {
        case .getRecommendedPlaces:
            return "/place-recommendations"
        case .postRecommendationChat:
            return "/place-recommendations/order/chat"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getRecommendedPlaces:
            return .get
        case .postRecommendationChat:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getRecommendedPlaces:
            return .requestPlain
        case .postRecommendationChat(let content):
            let requestDTO = ORBREcommendationChatRequestDTO(content: content)
            return .requestJSONEncodable(requestDTO)
        }
    }
}
