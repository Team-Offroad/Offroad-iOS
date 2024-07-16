//
//  ProfileAPI.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 7/15/24.
//

import Foundation

import Moya

enum ProfileAPI {
    case updateProfile(nickname: String, year: Int, month: Int, day: Int, gender: String)
}

extension ProfileAPI: BaseTargetType {

    var headerType: HeaderType { return .accessTokenHeaderForGeneral }
        
    var path: String {
        switch self {
        case .updateProfile:
            return "/users/profiles"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .updateProfile:
            return .patch
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .updateProfile(
            let nickname,
            let year,
            let month,
            let day,
            let gender
        ):
            return .requestParameters(
                parameters: [
                    "nickname": nickname,
                    "year": year,
                    "month": month,
                    "day": day,
                    "gender": gender
                ],
                encoding: URLEncoding.queryString
            )
        }
    }
}


