//
//  CharacterChatGetResponseDTO.swift
//  Offroad-iOS
//
//  Created by 김민성 on 11/14/24.
//

import Foundation

struct CharacterChatGetResponseDTO: Codable {
    var message: String
    var chatDataList: [ChatData]
}


