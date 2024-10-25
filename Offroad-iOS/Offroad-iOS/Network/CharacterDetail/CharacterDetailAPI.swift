////
////  CharacterDetailAPI.swift
////  Offroad-iOS
////
////  Created by  정지원 on 9/9/24.
////
//
//import Foundation
//
//import Moya
//
//enum CharacterDetailAPI {
//    case getCharacterDetail(characterId: Int)
//}
//
//extension CharacterDetailAPI: BaseTargetType {
//    
//    var headerType: HeaderType { return .accessTokenHeaderForGet }
//    
//    var parameter: [String : Any]? {
//        switch self {
//        case .getCharacterDetail:
//            return .none
//        }
//    }
//    var path: String {
//        switch self {
//        case .getCharacterDetail(let characterId):
//            return "/characters/\(characterId)"
//        }
//    }
//    
//    var method: Moya.Method {
//        switch self {
//        case .getCharacterDetail:
//            return .get
//        }
//    }
//    
//    var task: Moya.Task {
//        switch self {
//        case .getCharacterDetail:
//            return .requestPlain
//        }
//    }
//}
//
