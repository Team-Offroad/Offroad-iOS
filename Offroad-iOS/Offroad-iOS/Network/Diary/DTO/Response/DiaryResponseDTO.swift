//
//  DiaryResponseDTO.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 3/24/25.
//

struct DiaryLatestResponseDTO: Decodable {
    let message: String
    let data: DiaryLatestData
}

struct DiaryByDateResponseDTO: Decodable {
    let message: String
    let data: DiaryByDateData
}

struct DiaryLatestData: Decodable {
    let latestDiary: Diary
    let previousDiaries: [Diary]
    let emptyImageUrl: String
}

struct DiaryByDateData: Decodable {
    let latestDiary: Diary
    let previousDiaries: [Diary]
    let nextDiaries: [Diary]
}

struct Diary: Decodable {
    let id: Int
    let dailyRecommend: String
    let content: String
    let year: Int
    let month: Int
    let day: Int
    let summation: String
    let hexCodes: [String: [ColorHex]]
}
