//
//  CharacterChatReadGetResponseDTO.swift
//  Offroad-iOS
//
//  Created by 김민성 on 12/16/24.
//

import Foundation

struct CharacterChatReadGetResponseDTO: Codable {
    var message: String
    var data: CharacterChatReadGetResponseData
}

struct CharacterChatReadGetResponseData: Codable {
    var doesAllRead: Bool
    var characterName: String?
    var content: String?
}
