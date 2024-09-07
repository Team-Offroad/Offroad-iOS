//
//  AcquiredCouponAPI.swift
//  Offroad-iOS
//
//  Created by  정지원 on 9/8/24.
//

import Foundation

import Moya

enum AcquiredCouponAPI {
    case getCouponList
}

extension AcquiredCouponAPI: BaseTargetType {
    
    var headerType: HeaderType {
        switch self {
        case .getCouponList:
            return .accessTokenHeaderForGet
        }
    }
    
    var parameter: [String : Any]? {
        switch self {
        case .getCouponList:
            return nil
        }
    }
    
    var path: String {
        switch self {
        case .getCouponList:
            return "/users/coupons"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getCouponList:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getCouponList:
            return .requestParameters(parameters: parameter ?? [:], encoding: URLEncoding.queryString)
        }
    }
}

