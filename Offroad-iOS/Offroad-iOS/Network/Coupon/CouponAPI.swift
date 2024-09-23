//
//  CouponAPI.swift
//  Offroad-iOS
//
//  Created by 김민성 on 9/23/24.
//

import Foundation

import Moya

enum CouponAPI {
    case getCoupons
    case redeemCoupon (CouponRedemptionRequestDTO)
}

extension CouponAPI: BaseTargetType {
    var headerType: HeaderType {
        .accessTokenHeaderForGet
    }
    
    var path: String {
        switch self {
        case .getCoupons:
            "/users/coupons"
        case .redeemCoupon:
            "/users/coupons"
        }
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
        case .getCoupons:
            return .requestPlain
        case .redeemCoupon(let dto):
            return .requestJSONEncodable(dto)
        }
    }    
    
}
