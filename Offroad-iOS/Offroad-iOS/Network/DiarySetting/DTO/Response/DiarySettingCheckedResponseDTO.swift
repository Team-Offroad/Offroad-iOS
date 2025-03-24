//
//  DiarySettingCheckedResponseDTO.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 3/22/25.
//

import Foundation

struct DiarySettingCheckedResponseDTO: Decodable {
    let message: String
    let data: CheckedData
}

struct CheckedData: Decodable {
    let value: Bool
}
