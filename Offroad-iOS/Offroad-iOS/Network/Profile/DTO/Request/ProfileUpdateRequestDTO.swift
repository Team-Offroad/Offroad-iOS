//
//  ProfileUpdateRequestDTO.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 7/15/24.
//

import Foundation

struct ProfileUpdateRequestDTO: Codable {
    let nickname: String
    let year: Int?
    let month: Int?
    let day: Int?
    let gender: String?
    let characterId: Int
}
