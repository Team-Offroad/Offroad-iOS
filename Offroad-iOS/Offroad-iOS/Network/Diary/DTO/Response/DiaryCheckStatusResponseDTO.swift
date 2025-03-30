//
//  DiaryCheckStatusResponseDTO.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 3/24/25.
//

struct DiaryCheckStatusResponseDTO: Decodable {
    let message: String
    let data: DiaryCheckStatusData
}

struct DiaryCheckStatusData: Decodable {
    let doesNotExistOrChecked: Bool
}
