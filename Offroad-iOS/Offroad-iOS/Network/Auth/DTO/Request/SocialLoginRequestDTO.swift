//
//  SocialLoginRequestDTO.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 7/15/24.
//

import Foundation

struct SocialLoginRequestDTO: Codable {
    let socialPlatform: String
    let name: String?
    let code: String
}
