//
//  EmblemInfoResponseDTO.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 7/15/24.
//

import Foundation

struct EmblemInfoResponseDTO: Codable {
    let message: String
    let data: EmblemInfo
}

struct EmblemInfo: Codable {
    let emblems: [EmblemList]
}

struct EmblemList: Codable {
    let emblemCode: String
    let emblemName: String
}
