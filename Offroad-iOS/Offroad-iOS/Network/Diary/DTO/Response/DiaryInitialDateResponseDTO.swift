//
//  DiaryInitialDateResponseDTO.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 3/24/25.
//

struct DiaryInitialDateResponseDTO: Decodable {
    let message: String
    let data: DiaryInitialDateData
}

struct DiaryInitialDateData: Decodable {
    let year: Int
    let month: Int
    let day: Int
}
