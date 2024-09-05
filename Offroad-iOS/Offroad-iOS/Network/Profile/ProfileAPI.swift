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
    case patchMarketingConsent(body: MarketingConsentRequestDTO)
}

extension ProfileAPI: BaseTargetType {

    var headerType: HeaderType { return .accessTokenHeaderForGeneral }
        
    var path: String {
        switch self {
        case .updateProfile:
            return "/users/profiles"
        case .patchMarketingConsent:
            return "/users/agree"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .updateProfile, .patchMarketingConsent:
            return .patch
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .updateProfile(let profileUpdateRequestDTO):
            return .requestJSONEncodable(profileUpdateRequestDTO)
        case .patchMarketingConsent(let marketingConsentRequestDTO):
            return .requestJSONEncodable(marketingConsentRequestDTO)
        }
    }
}


