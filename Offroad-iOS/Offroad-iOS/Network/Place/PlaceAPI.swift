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
}

extension PlaceAPI: BaseTargetType {

    var headerType: HeaderType { return .noneHeader }
    
    var parameter: [String : Any]? {
        switch self {
        case .getRegisteredPlaces:
            return .none
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
        case .getRegisteredPlaces(let requestDTO):
            let jsonData = try? JSONEncoder().encode(requestDTO)
            return .requestCompositeData(bodyData: jsonData!, urlParameters: [:])
        }
    }
}
