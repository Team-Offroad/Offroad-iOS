//
//  AcquiredCharacterAPI.swift
//  Offroad-iOS
//
//  Created by  정지원 on 9/8/24.
//

import Foundation

import Moya

enum CharacterListAPI {
    case getCharacterListInfo
}

extension CharacterListAPI: BaseTargetType {

    var headerType: HeaderType { return .accessTokenHeaderForGet }
    
    var parameter: [String : Any]? {
        switch self {
        case .getCharacterListInfo:
            return .none
        }
    }
    
    var path: String {
        switch self {
        case .getCharacterListInfo:
            return "/users/characters"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getCharacterListInfo:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getCharacterListInfo:
            return .requestPlain
        }
    }
}



