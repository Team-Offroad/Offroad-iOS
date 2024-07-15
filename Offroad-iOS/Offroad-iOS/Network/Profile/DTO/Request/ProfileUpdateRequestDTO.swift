//
//  ProfileUpdateRequestDTO.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 7/15/24.
//

import Foundation

struct ProfileUpdateRequestDTO: Codable {
    let nickName: String
    let year: Int
    let month: Int
    let day: Int
    let gender: String
}
