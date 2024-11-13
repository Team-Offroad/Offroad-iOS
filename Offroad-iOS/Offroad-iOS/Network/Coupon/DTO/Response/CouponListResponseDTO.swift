//
//  CouponListDTO.swift
//  Offroad-iOS
//
//  Created by  정지원 on 9/10/24.
//

import Foundation

struct CouponListResponseDTO: Codable {
    let message: String
    let data: CouponData
}

struct CouponData: Codable {
    let coupons: [CouponInfo]
    let availableCouponsCount: Int
    let usedCouponsCount: Int
}

struct CouponInfo: Codable {
    let id: Int?
    let name: String
    let couponImageUrl: String
    let description: String?
    let isNewGained: Bool?
    let cursorId: Int
}

