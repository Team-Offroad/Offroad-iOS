//
//  CharacterChatPostResponseDTO.swift
//  Offroad-iOS
//
//  Created by 김민성 on 11/14/24.
//

import Foundation

struct CharacterChatPostResponseDTO: Codable {
    let message: String
    let data: ChatDataDTO
}

struct ChatDataDTO: Codable {
    let role: String // "USER" 또는 "ORB_CHARACTER"
    let content: String
    let createdAt: String
    let id: Int
}
