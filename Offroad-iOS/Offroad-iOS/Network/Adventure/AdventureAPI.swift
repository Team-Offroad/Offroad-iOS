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
    case adventureQRAuthentication(adventureQRAuth: AdventuresQRAuthenticationRequestDTO)
    case adventurePlaceAuthentication(adventurePlaceAuth: AdventuresPlaceAuthenticationRequestDTO)
}

extension AdventureAPI: BaseTargetType {

    var headerType: HeaderType {
        switch self {
        case .getAdventureInfo:
            return .accessTokenHeaderForGet
        case .adventureQRAuthentication:
            return .accessTokenHeaderForGeneral
        case .adventurePlaceAuthentication:
            return .accessTokenHeaderForGeneral
        }
    }
    
    var parameter: [String : Any]? {
        switch self {
        case .getAdventureInfo(let category):
            return ["category": category]
        case .adventureQRAuthentication:
            return nil
        case .adventurePlaceAuthentication:
            return nil
        }
    }
    
    var path: String {
        switch self {
        case .getAdventureInfo:
            return "/users/adventures/informations"
        case .adventureQRAuthentication:
            return "/users/adventures/authentication"
        case .adventurePlaceAuthentication:
            return "/users/places/distance"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getAdventureInfo:
            return .get
        case .adventureQRAuthentication:
            return .post
        case .adventurePlaceAuthentication:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getAdventureInfo:
            return .requestParameters(parameters: parameter ?? [:], encoding: URLEncoding.queryString)
        case .adventureQRAuthentication(let dto):
            return .requestJSONEncodable(dto)
        case .adventurePlaceAuthentication(let dto):
            return .requestJSONEncodable(dto)
        }
    }
}
