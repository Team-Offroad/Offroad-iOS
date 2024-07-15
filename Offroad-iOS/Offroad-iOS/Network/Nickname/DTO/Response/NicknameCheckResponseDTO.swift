//
//  NicknameCheckResponseDTO.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 7/15/24.
//

import Foundation

struct NicknameCheckResponseDTO: Codable {
    let message: String
    let data: NicknameCheckResultData
}

struct NicknameCheckResultData: Codable {
    let isDuplicate: Bool
}
