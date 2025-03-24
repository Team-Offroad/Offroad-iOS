//
//  DiaryColorsResponseDTO.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 3/24/25.
//

struct DiaryColorsResponseDTO: Decodable {
    let message: String
    let data: DiaryColorsData
}

struct DiaryColorsData: Decodable {
    let dailyHexCodes: [String: [ColorHex]]
    let firstDiaryDay: Int
}

struct ColorHex: Decodable {
    let small: String
    let large: String
}
