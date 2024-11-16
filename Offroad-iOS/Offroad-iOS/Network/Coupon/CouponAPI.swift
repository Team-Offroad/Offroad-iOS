//
//  CouponAPI.swift
//  Offroad-iOS
//
//  Created by 김민성 on 9/23/24.
//

import Foundation

import Moya

enum CouponAPI {
    case getCoupons(isUsed: Bool, size: Int, cursor: Int)
    case redeemCoupon(CouponRedemptionRequestDTO)
}

extension CouponAPI: BaseTargetType {
    var headerType: HeaderType {
        .accessTokenHeaderForGet
    }
    
    var path: String {
        "/users/coupons"
    }
    
    var method: Moya.Method {
        switch self {
        case .getCoupons:
            return .get
        case .redeemCoupon(_):
            return .post
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getCoupons(let isUsed, let size, let cursor):
            return .requestParameters(parameters: ["isUsed" : isUsed,
                                                   "size" : size,
                                                   "cursor" : cursor],
                                      encoding: URLEncoding.queryString)
        case .redeemCoupon(let dto):
            return .requestJSONEncodable(dto)
        }
    }    
    
}
