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

enum ChatDataModelError: LocalizedError {
    case invalidRole(wrongValue: String)
    case invalidDateFormat(wrongValue: String)
    case invalidTimeFormat(wrongValue: String)
    
    var errorDescription: String? {
        switch self {
        case .invalidRole(let wrongValue):
            return "서버 데이터의 role 응답값이 유효하지 않은 형식입니다: \(wrongValue). \"USER\" 또는 \"ORB_CHARACTER\" 만 유효합니다."
        case .invalidDateFormat(let wrongValue):
            return "서버 데이터의 날짜 응답값이 유효하지 않은 형식입니다: \(wrongValue)"
        case .invalidTimeFormat(let wrongValue):
            return "서버 데이터의 시간 응답값이 유효하지 않은 형식입니다: \(wrongValue)"
        }
    }
}

struct ChatDataModel: Hashable {
    
    enum ChatRole: String {
        case user = "USER"
        case orbCharacter = "ORB_CHARACTER"
    }
    
    let role: ChatRole
    let content: String
    let createdDate: Date?
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
    
    init(
        role: ChatRole,
        content: String,
        createdData: Date,
        id: Int? = nil,
        isLoading: Bool = false
    ) throws {
        self.role = role
        self.content = content
        self.createdDate = createdData
        self.id = id
        self.isLoading = isLoading
    }
    
    init(data: ChatDataDTO) throws {
        guard let chatRole = ChatRole(rawValue: data.role) else {
            throw ChatDataModelError.invalidRole(wrongValue: data.role)
        }
        self.role = chatRole
        self.content = data.content
        self.id = data.id
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate, .withTime, .withDashSeparatorInDate, .withColonSeparatorInTime]
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        if let date = formatter.date(from: data.createdAt) {
            self.createdDate = date
        } else {
            self.createdDate = nil
        }
    }
    
}
