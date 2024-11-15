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

struct ChatDataModel {
    var role: String
    var content: String
    var createdDate: Date
    
    init(data: ChatData) {
        let formatter = ISO8601DateFormatter()
        
        self.role = data.role
        self.content = data.content
        formatter.formatOptions = [.withFullDate, .withTime, .withDashSeparatorInDate, .withColonSeparatorInTime]
        guard let date = formatter.date(from: data.createdAt) else { fatalError() }
        self.createdDate = date
    }
    
}
