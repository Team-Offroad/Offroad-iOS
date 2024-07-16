//
//  BaseService.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 7/15/24.
//

import Foundation

class BaseService {
    
    /// 200 받았을 때 decoding 할 데이터가 있는 경우 (대부분의 GET)
    func fetchNetworkResult<T: Decodable>(statusCode: Int, data: Data) -> NetworkResult<T> {
        switch statusCode {
        case 200, 201:
            if let decodedData = fetchDecodeData(data: data, responseType: T.self) {
                return .success(decodedData)
            } else { return .decodeErr }
        case 400: return .requestErr
        case 401: return .unAuthentication
        case 403: return .unAuthorization
        case 404: return .apiArr
        case 405: return .pathErr
        case 409: return .requestErr
        default: return .networkFail
        }
    }
    
    /// 200 받았을 때 decoding 할 데이터가 없는 경우 (대부분의 PATCH, PUT, DELETE)
    func fetchNetworkResult(statusCode: Int, data: Data) -> NetworkResult<Any> {
        switch statusCode {
        case 200: return .success(nil)
        case 400: return .requestErr
        case 401: return .unAuthentication
        case 403: return .unAuthorization
        case 404: return .apiArr
        case 405: return .pathErr
        case 409: return .requestErr
        default: return .networkFail
        }
    }
    
    func fetchDecodeData<T: Decodable>(data: Data, responseType: T.Type) -> T? {
        let decoder = JSONDecoder()
        if let decodedData = try? decoder.decode(responseType, from: data){
            return decodedData
        } else { return nil }
    }
}
