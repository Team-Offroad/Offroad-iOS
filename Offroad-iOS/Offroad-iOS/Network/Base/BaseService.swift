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
        var decodeErrorResponse: ErrorResponseDTO? {
            fetchDecodeData(data: data, responseType: ErrorResponseDTO.self)
        }
        
        switch statusCode {
        case 200, 201, 202:
            if let decodedData = fetchDecodeData(data: data, responseType: T.self) {
                return .success(decodedData)
            } else { return .decodeErr }
        case 204: return .success(nil)
        case 400: return .requestErr(decodeErrorResponse)
        case 401: return .unAuthentication(decodeErrorResponse)
        case 403: return .unAuthorization(decodeErrorResponse)
        case 404: return .apiArr(decodeErrorResponse)
        case 405: return .pathErr(decodeErrorResponse)
        case 409: return .requestErr(decodeErrorResponse)
        case 500...599: return .serverErr(decodeErrorResponse)
        default: return .networkFail(decodeErrorResponse)
        }
    }
    
    /// 200 받았을 때 decoding 할 데이터가 없는 경우 (대부분의 PATCH, PUT, DELETE)
    func fetchNetworkResult(statusCode: Int, data: Data) -> NetworkResult<Any> {
        var decodeErrorResponse: ErrorResponseDTO? {
            fetchDecodeData(data: data, responseType: ErrorResponseDTO.self)
        }
        
        switch statusCode {
        case 200, 201, 204: return .success(nil)
        case 400: return .requestErr(decodeErrorResponse)
        case 401: return .unAuthentication(decodeErrorResponse)
        case 403: return .unAuthorization(decodeErrorResponse)
        case 404: return .apiArr(decodeErrorResponse)
        case 405: return .pathErr(decodeErrorResponse)
        case 409: return .requestErr(decodeErrorResponse)
        case 500...599: return .serverErr(decodeErrorResponse)
        default: return .networkFail(decodeErrorResponse)
        }
    }
    
    func fetchDecodeData<T: Decodable>(data: Data, responseType: T.Type) -> T? {
        let decoder = JSONDecoder()
        if let decodedData = try? decoder.decode(responseType, from: data){
            return decodedData
        } else { return nil }
    }
    
    func fetchErrorMessageData(data: Data) -> ErrorResponseDTO? {
        let decoder = JSONDecoder()
        if let decodedData = try? decoder.decode(ErrorResponseDTO.self, from: data) {
            return decodedData
        } else { return nil }
    }
}
