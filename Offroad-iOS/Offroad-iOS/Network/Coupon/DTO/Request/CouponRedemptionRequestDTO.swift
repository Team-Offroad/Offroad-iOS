//
//  CouponRedemptionRequestDTO.swift
//  Offroad-iOS
//
//  Created by 김민성 on 9/23/24.
//

import Foundation

struct CouponRedemptionRequestDTO: Codable {
    let code: String
    let couponId: Int
}
