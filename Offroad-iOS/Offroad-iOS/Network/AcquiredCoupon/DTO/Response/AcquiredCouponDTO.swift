//
//  AcquiredCouponDTO.swift
//  Offroad-iOS
//
//  Created by  정지원 on 9/8/24.
//

import Foundation

struct AcquiredCouponResponseDTO: Codable {
    let message: String
    let data: CouponData
}

struct CouponData: Codable {
    let availableCoupons: [AvailableCouponList]
    let usedCoupons: [UsedCouponList]
}

struct AvailableCouponList: Codable {
    let id: Int
    let name: String
    let couponImageUrl: String
    let description: String
    let isNewGained: Bool
}

struct UsedCouponList: Codable {
    let name: String
    let couponImageUrl: String
    let isNewGained: Bool
}
