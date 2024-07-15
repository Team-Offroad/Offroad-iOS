//
//  AdventureInfoResponseDTO.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 7/16/24.
//

import Foundation

struct AdventureInfoResponseDTO: Codable {
    let message: String
    let data: AdventureInfoData
}

struct AdventureInfoData: Codable {
    let nickname: String
    let characterImageUrl: String
    let characterName: String
    let emblemName: String
}
