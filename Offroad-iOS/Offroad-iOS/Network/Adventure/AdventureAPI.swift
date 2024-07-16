//
//  AdventureAPI.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 7/15/24.
//

import Foundation

import Moya

enum AdventureAPI {
    case getAdventureInfo
}

extension AdventureAPI: BaseTargetType {

    var headerType: HeaderType { return .accessTokenHeaderForGet }
    
    var parameter: [String : Any]? {
        switch self {
        case .getAdventureInfo:
            return ["category": "NONE"]
        }
    }
    
    var path: String {
        switch self {
        case .getAdventureInfo:
            return "/users/adventures/informations"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getAdventureInfo:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getAdventureInfo:
            return .requestParameters(parameters: parameter ?? [:], encoding: URLEncoding.queryString)
        }
    }
}
