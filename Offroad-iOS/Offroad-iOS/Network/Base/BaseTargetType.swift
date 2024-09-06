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
    case accessTokenHeaderForGet
    case accessTokenHeaderForGeneral
    case refreshTokenHeader
}

protocol BaseTargetType: TargetType {
    var headerType: HeaderType { get }
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
        
        switch headerType {
        case .noneHeader:
            return .none
        case .accessTokenHeaderForGet:
            guard let accessToken = KeychainManager.shared.loadAccessToken() else { return [:] }
            
            let header = ["Authorization": "Bearer \(accessToken)"]
            
            return header
        case .accessTokenHeaderForGeneral:
            guard let accessToken = KeychainManager.shared.loadAccessToken() else { return [:] }
            
            let header = ["Content-Type": "application/json",
                          "Authorization": "Bearer \(accessToken)"]
            return header
        case .refreshTokenHeader:
            guard let refreshToken = KeychainManager.shared.loadRefreshToken() else { return [:] }
            
            let header = ["Authorization": "Bearer \(refreshToken)"]
            
            return header
        }
    }
    
    var validationType: ValidationType {
        return .successCodes
    }
}
