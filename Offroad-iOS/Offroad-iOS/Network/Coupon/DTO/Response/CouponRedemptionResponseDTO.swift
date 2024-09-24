//
//  CouponRedemptionResponseDTO.swift
//  Offroad-iOS
//
//  Created by 김민성 on 9/23/24.
//

import Foundation

struct CouponRedemptionResponseDTO: Codable {
    let message: String
    let data: CouponRedemptionResult
}

struct CouponRedemptionResult: Codable {
    let success: Bool
}
