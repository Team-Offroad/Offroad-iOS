//
//  CharacterAPI.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 7/15/24.
//

import Foundation

import Moya

enum CharacterAPI {
    case getStartingCharacterList
    case postChoosingCharacter(characterID: Int)
    case getCharacterList
    case getCharacterDetail(characterId: Int)
    case getCharacterMotionList(characterId: Int)
}

extension CharacterAPI: BaseTargetType {

    var headerType: HeaderType {
        switch self {
        case .getStartingCharacterList, .getCharacterList, .getCharacterDetail, .getCharacterMotionList:
            return .accessTokenHeaderForGet
        case .postChoosingCharacter:
            return .accessTokenHeaderForGeneral
        }
    }
    
    var parameter: [String : Any]? {
        switch self {
        case .getStartingCharacterList, .postChoosingCharacter, .getCharacterList, .getCharacterDetail, .getCharacterMotionList:
            //return [:]
            return .none
        }
    }
    
    var path: String {
        switch self {
        case .getStartingCharacterList:
            return "/characters"
        case .postChoosingCharacter(let characterId):
            return "/users/characters/\(characterId)"
        case .getCharacterList:
            return "/users/characters"
        case .getCharacterDetail(let characterId):
            return "/characters/\(characterId)"
        case .getCharacterMotionList(let characterId):
            return "/motions/\(characterId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getStartingCharacterList, .getCharacterList, .getCharacterDetail, .getCharacterMotionList:
            return .get
        case .postChoosingCharacter:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getStartingCharacterList:
            return .requestParameters(parameters: parameter ?? [:], encoding: URLEncoding.queryString)
        case .postChoosingCharacter, .getCharacterList, .getCharacterDetail, .getCharacterMotionList:
            return .requestPlain
        }
    }
}

