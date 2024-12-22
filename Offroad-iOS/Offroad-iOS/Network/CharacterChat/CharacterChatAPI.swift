//
//  CharacterChatAPI.swift
//  Offroad-iOS
//
//  Created by 김민성 on 11/14/24.
//

import Foundation

import Moya

enum CharacterChatAPI {
    case postChat(characterId: Int? = nil, body: CharacterChatPostRequestDTO)
    case getChatLog(characterId: Int? = nil, limit: Int, cursor: Int? = nil)
    case patchChatRead(characterId: Int? = nil)
    case getLastChatInfo
}

extension CharacterChatAPI: BaseTargetType {
    var headerType: HeaderType {
        .accessTokenHeaderForGet
    }
    
    var path: String {
        switch self {
        case .postChat, .getChatLog:
           return  "/chats"
        case .patchChatRead:
            return "/chats/read"
        case .getLastChatInfo:
            return "/chats/last-unread"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .postChat: .post
        case .patchChatRead: .patch
        case .getChatLog, .getLastChatInfo: .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .postChat(characterId: let characterId, body: let body):
            guard let characterId else { return .requestJSONEncodable(body) }
            return .requestCompositeParameters(
                bodyParameters: ["content": body.content],
                bodyEncoding: JSONEncoding.default,
                urlParameters: ["characterId" : characterId]
            )
        case .getChatLog(characterId: let characterId, limit: let limit, cursor: let cursor):
            var queryParameters: [String: Any] = [:]
            if let characterId { queryParameters["characterId"] = characterId }
            queryParameters["limit"] = limit
            if let cursor { queryParameters["cursor"] = cursor }
            return .requestParameters(parameters: queryParameters, encoding: URLEncoding.queryString)
        case .patchChatRead(characterId: let characterId):
            var queryParameters: [String: Any] = [:]
            if let characterId { queryParameters["characterId"] = characterId }
            return .requestParameters(parameters: queryParameters, encoding: URLEncoding.queryString)
        case .getLastChatInfo:
            return .requestPlain
        }
    }
    
    
}
