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
    var id: Int
}

struct ChatDataModel: Hashable {
    var role: String
    var content: String
    var createdDate: Date?
    // id가 옵셔널 타입인 이유는 사용자가 채팅을 보낸 직후의 채팅 말풍선은 아직 서버에 저장되기 전이므로 id를 알 수 없기 때문
    var id: Int?
    var isLoading: Bool = false
    
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
    
    init(role: String, content: String, createdData: Date?, id: Int? = nil, isLoading: Bool = false) {
        self.role = role
        self.content = content
        self.createdDate = createdData
        self.id = id
        self.isLoading = isLoading
    }
    
    init(data: ChatData) {
        let formatter = ISO8601DateFormatter()
        
        self.role = data.role
        self.content = data.content
        self.id = data.id
        formatter.formatOptions = [.withFullDate, .withTime, .withDashSeparatorInDate, .withColonSeparatorInTime]
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        if let date = formatter.date(from: data.createdAt) {
            self.createdDate = date
        } else {
            self.createdDate = nil
        }
    }
    
}
