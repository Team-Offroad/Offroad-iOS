//
//  CharacterChatPostResponseDTO.swift
//  Offroad-iOS
//
//  Created by 김민성 on 11/14/24.
//

import Foundation

struct CharacterChatPostResponseDTO: Codable {
    var message: String
    var data: ChatData
}

struct ChatData: Codable {
    var role: String // "USER" 또는 "ORB_CHARACTER"
    var content: String
    var createdAt: String
}
