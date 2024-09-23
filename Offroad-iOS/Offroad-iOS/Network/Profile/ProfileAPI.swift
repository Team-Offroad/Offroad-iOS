//
//  ProfileAPI.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 7/15/24.
//

import Foundation

import Moya

enum ProfileAPI {
    case patchUpdateProfile(body: ProfileUpdateRequestDTO)
    case postDeleteAccount(body: DeleteAccountRequestDTO)
    case patchMarketingConsent(body: MarketingConsentRequestDTO)
    case getUserInfo
}

extension ProfileAPI: BaseTargetType {

    var headerType: HeaderType { return .accessTokenHeaderForGeneral }
    
    var parameter: [String : Any]? {
        switch self {
        case .patchUpdateProfile, .postDeleteAccount, .patchMarketingConsent, .getUserInfo:
            return nil
        }
    }
        
    var path: String {
        switch self {
        case .patchUpdateProfile:
            return "/users/profiles"
        case .postDeleteAccount:
            return "/users/delete"
        case .patchMarketingConsent:
            return "/users/agree"
        case .getUserInfo:
            return "/users/me"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .patchUpdateProfile, .patchMarketingConsent:
            return .patch
        case .postDeleteAccount:
            return .post
        case .getUserInfo:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .patchUpdateProfile(let profileUpdateRequestDTO):
            return .requestJSONEncodable(profileUpdateRequestDTO)
        case .postDeleteAccount(let deleteAccountRequestDTO):
            return .requestJSONEncodable(deleteAccountRequestDTO)
        case .patchMarketingConsent(let marketingConsentRequestDTO):
            return .requestJSONEncodable(marketingConsentRequestDTO)
        case .getUserInfo:
            return .requestParameters(parameters: parameter ?? [:], encoding: URLEncoding.queryString)
        }
    }
}


