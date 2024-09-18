//
//  CharacterDetailAPI.swift
//  Offroad-iOS
//
//  Created by  정지원 on 9/9/24.
//

import Foundation

import Moya

enum CharacterDetailAPI {
    case getCharacterDetailList(characterId: Int)
}

extension CharacterDetailAPI: BaseTargetType {
    
    var headerType: HeaderType { return .accessTokenHeaderForGet }
    
    var parameter: [String : Any]? {
        switch self {
        case .getCharacterDetailList:
            return .none
        }
    }
    var path: String {
        switch self {
        case .getCharacterDetailList(let characterId):
            return "/characters/\(characterId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getCharacterDetailList:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getCharacterDetailList:
            return .requestPlain
        }
    }
}

