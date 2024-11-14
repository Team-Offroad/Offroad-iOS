//
//  CharacterChatAPI.swift
//  Offroad-iOS
//
//  Created by 김민성 on 11/14/24.
//

import Foundation

import Moya

enum CharacterChatAPI {
    case postChat(body: CharacterChatPostRequestDTO)
    case getChatLog
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
        case .postChat(body: let body):
            return .requestJSONEncodable(body)
        case .getChatLog:
            return .requestPlain
        }
    }
    
    
}
