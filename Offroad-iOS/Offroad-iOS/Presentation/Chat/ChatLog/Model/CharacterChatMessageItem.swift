//
//  CharacterChatMessageItem.swift
//  Offroad-iOS
//
//  Created by 김민성 on 6/15/25.
//

import Foundation

/// 채팅 로그의 말풍선 중 채팅 대화 내용에 해당하는 데이터 모델
enum CharacterChatMessageItem: Hashable {
    
    /// 사용자가 보낸 채팅 아이템
    ///
    /// 채팅을 보낸 직후 서버에 반영된 데이터를 받아오기 전까지 `id` 값을 알 수 없으므로 id 타입은 `Int?`.
    case user(content: String, createdDate: Date, id: Int?)
    
    /// 오브 캐릭터가 답장한 채팅 아이템
    ///
    /// 채팅 중에 서버에서 캐릭터 선톡을 날리는 경우 서버에서 `id` 정보를 같이 넘겨주지 않으므로 이때 `id` 값은 `nil`
    /// - Note: 서버 로직이 업데이트되었을 수 있으므로 캐릭터 선톡 시 `id` 값을 같이 넘겨주는지 확인 후 업데이트 필요.
    case orbCharacter(content: String, createdDate: Date, id: Int?)
    
    #if DevTarget
    /// 오브 캐릭터가 장소 추천 요청임을 인지하고 '오브의 추천소'로 유도하는 채팅 아이템
    case orbRecommendation(content: String, createdDate: Date, id: Int)
    #endif
    
}

extension CharacterChatMessageItem {
    
    var createdDate: Date {
        switch self {
        case .user(_, let createdDate, _),
                .orbCharacter(_, let createdDate, _):
            return createdDate
        #if DevTarget
        case .orbRecommendation(_, let createdDate, _):
            return createdDate
        #endif
        }
    }
    
    var id: Int? {
        switch self {
        case .user(_, _, let id), .orbCharacter(_, _, let id):
            return id
        #if DevTarget
        case .orbRecommendation(_, _, let id):
            return id
        #endif
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
                #if DevTarget
                if dto.isPlaceRecommendation {
                    return .orbRecommendation(
                        content: dto.content,
                        createdDate: try decodeToDate(from: dto.createdAt),
                        id: dto.id
                    )
                } else {
                    return .orbCharacter(
                        content: dto.content,
                        createdDate: try decodeToDate(from: dto.createdAt),
                        id: dto.id
                    )
                }
                #else
                return .orbCharacter(
                    content: dto.content,
                    createdDate: try decodeToDate(from: dto.createdAt),
                    id: dto.id
                )
                #endif
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
    
    /// 화면에 표시되는 날짜 문자열
    var formattedDateString: String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "M월 d일 EEEE"
        return formatter.string(from: createdDate)
    }
    
    /// 화면에 표시되는 채팅 아이템의 시간 문자열
    var formattedTimeString: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "a hh:mm"
        return dateFormatter.string(from: createdDate)
    }
    
}
