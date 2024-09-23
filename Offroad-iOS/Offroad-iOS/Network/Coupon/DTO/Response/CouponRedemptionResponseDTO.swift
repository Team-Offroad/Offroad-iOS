//
//  CouponRedemptionResponseDTO.swift
//  Offroad-iOS
//
//  Created by 김민성 on 9/23/24.
//

import Foundation

struct CouponRedemptionResponseDTO: Codable {
    let message: String
    fileprivate let data: CouponRedemptionResult
}

fileprivate struct CouponRedemptionResult: Codable {
    let success: Bool
}
