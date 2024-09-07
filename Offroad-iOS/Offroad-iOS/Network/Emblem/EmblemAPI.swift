//
//  EmblemAPI.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 7/15/24.
//

import Foundation

import Moya

enum EmblemAPI {
    case getEmblemInfo
    case patchUserEmblem(emBlemCode: String)
    case getEmblemDataList
}

extension EmblemAPI: BaseTargetType {

    var headerType: HeaderType { return .accessTokenHeaderForGet }
    
    var parameter: [String : Any]? {
        switch self {
        case .getEmblemInfo, .getEmblemDataList:
            return .none
        case .patchUserEmblem(let emblemCode):
            return ["emblemCode" : emblemCode]
        }
    }
    
    var path: String {
        switch self {
        case .getEmblemInfo, .patchUserEmblem:
            return "/users/emblems"
        case .getEmblemDataList:
            return "/emblems"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getEmblemInfo, .getEmblemDataList:
            return .get
        case .patchUserEmblem:
            return .patch
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getEmblemInfo, .patchUserEmblem, .getEmblemDataList:
            return .requestParameters(parameters: parameter ?? [:], encoding: URLEncoding.queryString)
        }
    }
}
