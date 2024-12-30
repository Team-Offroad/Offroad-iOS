//
//  PushNotificationAPI.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 11/14/24.
//

import Foundation

import Moya

enum PushNotificationAPI {
    case postFcmToken(body: FcmTokenRequestDTO)
}

extension PushNotificationAPI: BaseTargetType {

    var headerType: HeaderType {
        switch self {
        case .postFcmToken:
            return .accessTokenHeaderForGeneral
        }
    }
    
    var parameter: [String : Any]? {
        switch self {
        case .postFcmToken:
            return .none
        }
    }
    
    var path: String {
        switch self {
        case .postFcmToken:
            return "/fcm/token"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .postFcmToken:
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .postFcmToken(let fcmTokenRequestDTO):
            return .requestJSONEncodable(fcmTokenRequestDTO)
        }
    }
}
