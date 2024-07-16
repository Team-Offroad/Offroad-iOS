//
//  QuestAPI.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 7/15/24.
//

import Foundation

import Moya

enum QuestAPI {
    case getQuestInfo
}

extension QuestAPI: BaseTargetType {

    var headerType: HeaderType { return .accessTokenHeaderForGet }
    
    var parameter: [String : Any]? {
        switch self {
        case .getQuestInfo:
            return .none
        }
    }
    
    var path: String {
        switch self {
        case .getQuestInfo:
            return "/users/quests"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getQuestInfo:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getQuestInfo:
            return .requestPlain
        }
    }
}

