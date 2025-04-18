//
//  CharacterChatItem.swift
//  Offroad-iOS
//
//  Created by 김민성 on 4/18/25.
//

import Foundation

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
        case .message(let chatMessageModel):
            return chatMessageModel.createdDate
        case .loading(let createdDate):
            return createdDate
        }
    }
    
    var formattedTimeString: String {
        switch self {
        case .message(let chatMessageModel):
            return chatMessageModel.formattedTimeString
        case .loading(let createdDate):
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "ko_KR")
            dateFormatter.dateFormat = "a hh:mm"
            return dateFormatter.string(from: createdDate)
        }
    }
}

/// 채팅 로그의 말풍선 중 채팅 대화 내용에 해당하는 데이터 모델
enum CharacterChatMessageItem: Hashable {
    
    // 채팅을 보낸 직후 서버에 반영된 데이터를 받아오기 전까지 `id` 값을 알 수 없으므로 nil.
    case user(content: String, createdDate: Date, id: Int?)
    
    // 채팅 중에 서버에서 캐릭터 선톡을 날리는 경우에는 서버에서 `id` 정보를 같이 넘겨주지 않으므로 이때 `id` 값은 `nil`
    case orbCharacter(content: String, createdDate: Date, id: Int?)
    
    var createdDate: Date {
        switch self {
        case .user(_, let createdDate, _),
             .orbCharacter(_, let createdDate, _):
            return createdDate
        }
    }
    
    /// `ChatDataDTO`를 사용하여 생성하고자 하는 경우
    static func from(dto: ChatDataDTO) throws -> CharacterChatMessageItem {
        switch dto.role {
        case "USER":
            do {
                return .user(
                    content: dto.content,
                    createdDate: try decodeToDate(from: dto.createdAt),
                    id: dto.id
                )
            } catch {
                throw CharacterChatItemError.invalidDateFormat(wrongValue: dto.createdAt)
            }
        case "ORB_CHARACTER":
            do {
                return .orbCharacter(
                    content: dto.content,
                    createdDate: try decodeToDate(from: dto.createdAt),
                    id: dto.id
                )
            } catch {
                throw CharacterChatItemError.invalidTimeFormat(wrongValue: dto.createdAt)
            }
        default:
            throw CharacterChatItemError.invalidRole(wrongValue: dto.role)
        }
    }
    
    static func decodeToDate(from dateString: String) throws -> Date {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withFullDate, .withTime, .withDashSeparatorInDate, .withColonSeparatorInTime]
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        if let date = formatter.date(from: dateString) {
            return date
        } else {
            throw CharacterChatItemError.invalidDateFormat(wrongValue: dateString)
        }
    }
    
}


extension CharacterChatMessageItem {
    
    var formattedDateString: String {
        switch self {
        case .user(_, let createdDate, _):
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ko_KR")
            formatter.dateFormat = "M월 d일 EEEE"
            return formatter.string(from: createdDate)
        case .orbCharacter(_, let createdDate, _):
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ko_KR")
            formatter.dateFormat = "M월 d일 EEEE"
            return formatter.string(from: createdDate)
        }
    }
    
    var formattedTimeString: String {
        switch self {
        case .user(_, let createdDate, _):
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "ko_KR")
            dateFormatter.dateFormat = "a hh:mm"
            return dateFormatter.string(from: createdDate)
            
        case .orbCharacter(_, let createdDate, _):
            let dateFormatter = DateFormatter()
            dateFormatter.locale = Locale(identifier: "ko_KR")
            dateFormatter.dateFormat = "a hh:mm"
            return dateFormatter.string(from: createdDate)
        }
    }
    
}
