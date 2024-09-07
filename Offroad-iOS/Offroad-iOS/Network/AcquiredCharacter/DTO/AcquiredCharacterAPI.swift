//
//  AcquiredCharacterAPI.swift
//  Offroad-iOS
//
//  Created by  정지원 on 9/8/24.
//

import Foundation

import Moya

enum AcquiredCharacterAPI {
    case getAcquiredCharacterInfo
}

extension AcquiredCharacterAPI: BaseTargetType {

    var headerType: HeaderType { return .accessTokenHeaderForGet }
    
    var parameter: [String : Any]? {
        switch self {
        case .getAcquiredCharacterInfo:
            return .none
        }
    }
    
    var path: String {
        switch self {
        case .getAcquiredCharacterInfo:
            return "/users/characters"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getAcquiredCharacterInfo:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getAcquiredCharacterInfo:
            return .requestPlain
        }
    }
}


