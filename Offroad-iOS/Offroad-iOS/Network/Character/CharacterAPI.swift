//
//  CharacterAPI.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 7/15/24.
//

import Foundation

import Moya

enum CharacterAPI {
    case getCharacterInfo
}

extension CharacterAPI: BaseTargetType {

    var headerType: HeaderType { return .accessTokenHeaderForGet }
    
    var parameter: [String : Any]? {
        switch self {
        case .getCharacterInfo:
            return [:]
        }
    }
    
    var path: String {
        switch self {
        case .getCharacterInfo:
            return "/characters"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getCharacterInfo:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getCharacterInfo:
            return .requestParameters(parameters: parameter ?? [:], encoding: URLEncoding.queryString)
        }
    }
}

