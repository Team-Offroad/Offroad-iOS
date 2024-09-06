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
//    case getRegisteredPlaces(coordinate: CLLocationCoordinate2D, limit: Int, isBounded: Bool)
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
        }
    }
    
    var path: String {
        switch self {
        case .getRegisteredPlaces:
            return "/places"
        }
    }
    
    var method: Moya.Method {
        switch self {
        case .getRegisteredPlaces:
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
        }
    }
}
