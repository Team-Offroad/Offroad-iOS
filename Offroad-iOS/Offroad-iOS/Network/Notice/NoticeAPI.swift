//
//  NoticeAPI.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 9/23/24.
//

import Foundation

import Moya

enum NoticeAPI {
    case getNoticeList
}

extension NoticeAPI: BaseTargetType {

    var headerType: HeaderType {
        switch self {
        case .getNoticeList:
            return .accessTokenHeaderForGet
        }
    }
    
    var parameter: [String : Any]? {
        switch self {
        case .getNoticeList:
            return .none
        }
    }
    
    var path: String {
        switch self {
        case .getNoticeList:
            return "/announcement"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getNoticeList:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getNoticeList:
            return .requestPlain
        }
    }
}
