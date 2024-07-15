//
//  BaseTargetType.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 7/15/24.
//

import Foundation

import Moya

enum HeaderType {
    case noneHeader
    case accessTokenHeader
}

protocol BaseTargetType: TargetType {
    var headerType: HeaderType { get }
    var parameter: [String : Any]? { get }
}

extension BaseTargetType {
    
    var baseURL: URL {
        guard let urlString = Bundle.main.infoDictionary?["BASE_URL"] as? String,
              let url = URL(string: urlString) else {
            fatalError("🚨Base URL을 찾을 수 없습니다🚨")
        }
        return url
    }
        
    var headers: [String: String]? {
        var header = [
            "Content-Type": "application/json"
        ]
        
        switch headerType {
        case .noneHeader:
            return .none
        case .accessTokenHeader:
            if let token = Bundle.main.infoDictionary?["TempAccessToken"] as? String {
                header["Authorization"] = "Bearer \(token)"
            }
            return header
        }
    }
    
    var task: Task {
        if let parameter = parameter {
            return .requestParameters(parameters: parameter, encoding: URLEncoding.default)
        } else {
            return .requestPlain
        }
    }
    
    var sampleData: Data {
        return Data()
    }
}
