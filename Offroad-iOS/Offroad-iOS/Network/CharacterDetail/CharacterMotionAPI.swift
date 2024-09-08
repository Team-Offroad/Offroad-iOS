//
//  CharacterMotionAPI.swift
//  Offroad-iOS
//
//  Created by  정지원 on 9/9/24.
//

import Foundation

import Moya

enum CharacterMotionAPI {
    case getCharacterMotionList(characterId: Int)
}

extension CharacterMotionAPI: BaseTargetType {
    
    var headerType: HeaderType { return .accessTokenHeaderForGet }
    
    var parameter: [String : Any]? {
        switch self {
        case .getCharacterMotionList:
            return .none
        }
    }
    var path: String {
        switch self {
        case .getCharacterMotionList(let characterId):
            return "/motions/\(characterId)"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getCharacterMotionList:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getCharacterMotionList:
            return .requestPlain
        }
    }
}


