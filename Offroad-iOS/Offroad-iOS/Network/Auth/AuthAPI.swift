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
        case .postSocialLogin:
            return .none
        case .postRefreshToken:
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
        case .postSocialLogin:
            return .post
        case .postRefreshToken:
            return .post
        }
    }
    
    var headers: [String : String]? {
        var header =  [
            "Content-Type": "application/json"
        ]
        
        switch self {
        case .postSocialLogin(let body):
            guard let accessToken = UserDefaults.standard.string(forKey: "AccessToken") else { return [:] }
            
            header["Authorization"] = "Bearer \(accessToken)"
            return header
        case .postRefreshToken:
            return .none
        }
    }
}
