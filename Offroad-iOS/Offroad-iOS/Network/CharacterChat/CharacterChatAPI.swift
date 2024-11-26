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
    case getChatLog(characterId: Int? = nil)
}

extension CharacterChatAPI: BaseTargetType {
    var headerType: HeaderType {
        .accessTokenHeaderForGet
    }
    
    var path: String {
        "/chats"
    }
    
    var method: Moya.Method {
        switch self {
        case .postChat: .post
        case .getChatLog: .get
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
        case .getChatLog(characterId: let characterId):
            guard let characterId else { return .requestPlain }
            return .requestParameters(parameters: ["characterId" : characterId], encoding: URLEncoding.queryString)
        }
    }
    
    
}
