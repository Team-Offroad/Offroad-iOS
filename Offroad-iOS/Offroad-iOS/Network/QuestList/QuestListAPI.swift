//
//  QuestListAPI.swift
//  Offroad-iOS
//
//  Created by 김민성 on 8/27/24.
//

import Foundation

import Moya

enum QuestListAPI {
    case getQuestList(isActive: Bool)
}

extension QuestListAPI: BaseTargetType {
    
    var headerType: HeaderType {
        switch self {
        case .getQuestList:
            return .accessTokenHeaderForGet
        }
    }
    
    var path: String {
        return "/quests"
    }
    
    var method: Moya.Method {
        switch self {
        case .getQuestList:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getQuestList(let isActive):
            return .requestParameters(parameters: ["isActive" : isActive], encoding: URLEncoding.queryString)
        }
    }
    
    
}