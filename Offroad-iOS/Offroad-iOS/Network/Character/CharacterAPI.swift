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
    case postChoosingCharacter(characterID: Int)
}

extension CharacterAPI: BaseTargetType {

    var headerType: HeaderType {
        switch self {
        case .getCharacterInfo:
            return .accessTokenHeaderForGet
        case .postChoosingCharacter:
            return .accessTokenHeaderForGeneral
        }
    }
    
    var parameter: [String : Any]? {
        switch self {
        case .getCharacterInfo, .postChoosingCharacter:
            return [:]
        }
    }
    
    var path: String {
        switch self {
        case .getCharacterInfo:
            return "/characters"
        case .postChoosingCharacter(let characterId):
            return "/users/characters/\(characterId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getCharacterInfo:
            return .get
        case .postChoosingCharacter:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getCharacterInfo:
            return .requestParameters(parameters: parameter ?? [:], encoding: URLEncoding.queryString)
        case .postChoosingCharacter:
            return .requestPlain
        }
    }
}

