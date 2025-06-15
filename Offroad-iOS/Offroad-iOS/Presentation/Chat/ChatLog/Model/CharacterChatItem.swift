//
//  CharacterChatItem.swift
//  Offroad-iOS
//
//  Created by 김민성 on 4/18/25.
//

import Foundation

/// `CharacterChatItem` 을 생성하면서 발생할 수 있는 에러
enum CharacterChatItemError: LocalizedError {
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

/// 채팅 로그의 각 말풍선에 해당하는 데이터 모델.
enum CharacterChatItem: Hashable {
    case message(CharacterChatMessageItem)
    case loading(createdDate: Date)
    
    var createdDate: Date {
        switch self {
        case .message(let chatMessageItem):
            return chatMessageItem.createdDate
        case .loading(let createdDate):
            return createdDate
        }
    }
    
    var formattedTimeString: String {
        switch self {
        case .message(let messageItem):
            return messageItem.formattedTimeString
        case .loading(let createdDate):
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "ko_KR")
            dateFormatter.dateFormat = "a hh:mm"
            return dateFormatter.string(from: createdDate)
        }
    }
}
