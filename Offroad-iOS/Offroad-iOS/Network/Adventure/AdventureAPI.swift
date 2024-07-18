//
//  AdventureAPI.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 7/15/24.
//

import Foundation

import Moya

enum AdventureAPI {
    case getAdventureInfo(category: String)
    case adventureAuthentication(adventureAuth: AdventuresAuthenticationRequestDTO)
}

extension AdventureAPI: BaseTargetType {

    var headerType: HeaderType {
        switch self {
        case .getAdventureInfo:
            return .accessTokenHeaderForGet
        case .adventureAuthentication:
            return .accessTokenHeaderForGeneral
        }
    }
    
    var parameter: [String : Any]? {
        switch self {
        case .getAdventureInfo(let category):
            return ["category": category]
        case .adventureAuthentication:
            return nil
        }
    }
    
    var path: String {
        switch self {
        case .getAdventureInfo:
            return "/users/adventures/informations"
        case .adventureAuthentication:
            return "/users/adventures/authentication"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getAdventureInfo:
            return .get
        case .adventureAuthentication:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getAdventureInfo:
            return .requestParameters(parameters: parameter ?? [:], encoding: URLEncoding.queryString)
        case .adventureAuthentication(let dto):
            return .requestJSONEncodable(dto)
        }
    }
}
