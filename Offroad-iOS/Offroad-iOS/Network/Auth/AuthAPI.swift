//
//  AuthAPI.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 7/15/24.
//

import Foundation

import Moya

enum AuthAPI {
    case postSocialLogin(body: SocialLoginRequestDTO)
    case postRefreshToken
}

extension AuthAPI: BaseTargetType {

    var headerType: HeaderType { return .noneHeader }
    
    var parameter: [String : Any]? {
        switch self {
        case .postSocialLogin, .postRefreshToken:
            return .none
        }
    }
    
    var path: String {
        switch self {
        case .postSocialLogin:
            return "/oauth/login/apple"
        case .postRefreshToken:
            return "/auth/refresh"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .postSocialLogin, .postRefreshToken:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .postSocialLogin(let socialLoginRequestDTO):
            return .requestJSONEncodable(socialLoginRequestDTO)
        case .postRefreshToken:
            return .requestPlain
        }
    }
}
