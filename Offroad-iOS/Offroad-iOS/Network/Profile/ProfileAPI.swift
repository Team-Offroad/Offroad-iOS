//
//  ProfileAPI.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 7/15/24.
//

import Foundation

import Moya

enum ProfileAPI {
    case updateProfile(body: ProfileUpdateRequestDTO)
    case postMarketingConsent(parameter: Bool)
}

extension ProfileAPI: BaseTargetType {

    var headerType: HeaderType { return .accessTokenHeaderForGeneral }
        
    var path: String {
        switch self {
        case .updateProfile:
            return "/users/profiles"
        case .postMarketingConsent:
            return "/users/marketing"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .updateProfile:
            return .patch
        case .postMarketingConsent:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .updateProfile(let profileUpdateRequestDTO):
            return .requestJSONEncodable(profileUpdateRequestDTO)
        case .postMarketingConsent(let parameter):
            return .requestParameters(parameters: ["marketing": parameter], encoding: URLEncoding.queryString)
        }
    }
}


