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
    var createdDate: Date?
    var formattedTimeString: String {
        guard let createdDate else { return "" }
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "a hh:mm"
        return dateFormatter.string(from: createdDate)
    }
    var formattedDateString: String {
        guard let createdDate else { return "" }
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "M월 d일 EEEE"
        return dateFormatter.string(from: createdDate)
    }
    
    init(role: String, content: String, createdData: Date?) {
        self.role = role
        self.content = content
        self.createdDate = createdData
    }
    
    init(data: ChatData) {
        let formatter = ISO8601DateFormatter()
        
        self.role = data.role
        self.content = data.content
        formatter.formatOptions = [.withFullDate, .withTime, .withDashSeparatorInDate, .withColonSeparatorInTime]
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        if let date = formatter.date(from: data.createdAt) {
            self.createdDate = date
        } else {
            self.createdDate = nil
        }
    }
    
}
