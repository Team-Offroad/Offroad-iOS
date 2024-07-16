//
//  NicknameAPI.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 7/15/24.
//

import Foundation

import Moya

enum NicknameAPI {
    case checkNicknameDuplicate(inputNickname: String)
}

extension NicknameAPI: BaseTargetType {

    var headerType: HeaderType { return .accessTokenHeaderForGet }
        
    var path: String {
        switch self {
        case .checkNicknameDuplicate:
            return "/users/nickname/check"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .checkNicknameDuplicate:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .checkNicknameDuplicate(let inputNickname):
            return .requestParameters(parameters: ["nickname": inputNickname], encoding: URLEncoding.queryString)
        }
    }
}

