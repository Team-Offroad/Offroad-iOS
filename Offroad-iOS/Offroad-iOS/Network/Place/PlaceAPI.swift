//
//  PlaceAPI.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 7/15/24.
//

import Foundation

import Moya
import NMapsMap

enum PlaceAPI {
    case getRegisteredPlaces(requestDTO: RegisteredPlaceRequestDTO)
    case getRegisteredMapPlaces(latitude: Double, longitude: Double, limit: Int)
    case getRegisteredListPlaces(latitude: Double, longitude: Double, limit: Int, cursorDistance: Double?)
}

extension PlaceAPI: BaseTargetType {

    var headerType: HeaderType { return .accessTokenHeaderForGet }
    
    var headers: [String : String]? {
        guard let accessToken = KeychainManager.shared.loadAccessToken() else { return [:] }
        
        let header = ["Content-Type": "application/json",
                      "Authorization": "Bearer \(accessToken)"]
        return header
    }
    
    var parameter: [String : Any]? {
        switch self {
        case .getRegisteredPlaces(let dto):
            return [
                "currentLatitude": dto.currentLatitude,
                "currentLongitude": dto.currentLongitude,
                "limit": dto.limit,
                "isBounded": dto.isBounded
            ]
        case .getRegisteredMapPlaces(latitude: let latitude, longitude: let longitude, limit: let limit):
            return [
                "currentLatitude": latitude,
                "currentLongitude": longitude,
                "limit": limit
            ]
        case .getRegisteredListPlaces(latitude: let latitude, longitude: let longitude, limit: let limit, cursorDistance: let cursorDistance):
            var dict: [String: Any] = ["currentLatitude": latitude,
                                       "currentLongitude": longitude,
                                       "limit": limit]
            if let cursorDistance { dict["cursorDistance"] = cursorDistance }
            return dict
        }
    }
    
    var path: String {
        switch self {
        case .getRegisteredPlaces:
            return "/places"
        case .getRegisteredMapPlaces:
            return "/places/map"
        case .getRegisteredListPlaces:
            return "/places/list"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getRegisteredPlaces, .getRegisteredMapPlaces, .getRegisteredListPlaces:
            return .get
        }
    }
    
    var task: Moya.Task {
        switch self {
        case .getRegisteredPlaces:
            return .requestParameters(
                parameters: parameter ?? [:],
                encoding: URLEncoding.queryString
            )
        case .getRegisteredMapPlaces:
            return .requestParameters(
                parameters: parameter ?? [:],
                encoding: URLEncoding.queryString)
        case .getRegisteredListPlaces:
            return .requestParameters(parameters: parameter ?? [:], encoding: URLEncoding.queryString)
        }
    }
}
