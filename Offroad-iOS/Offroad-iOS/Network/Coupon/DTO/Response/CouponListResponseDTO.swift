//
//  CouponListDTO.swift
//  Offroad-iOS
//
//  Created by  정지원 on 9/10/24.
//

import Foundation

struct CouponListResponseDTO: Codable {
    let message: String
    let data: CouponListInfo
}

struct CouponListInfo: Codable {
    let availableCoupons: [AvailableCoupon]
    let usedCoupons: [UsedCoupon]
}

struct AvailableCoupon: Codable {
    let id: Int
    let name: String
    let couponImageUrl: String
    let description: String
    let isNewGained: Bool
}

struct UsedCoupon: Codable {
    let name: String
    let couponImageUrl: String
}

