//
//  NetworkResultHandler.swift
//  Offroad-iOS
//
//  Created by 김민성 on 6/4/25.
//

import Foundation

import Alamofire
import Moya

/// provider.request 메서드의 콜백 함수를 통해 반환된 Result 값들을 처리하는 타입.
struct NetworkResultHandler {
    
    /// `Moya.Response`를 처리하여 디코딩된 DTO 인스턴스를 반환하는 함수.
    /// - Parameters:
    ///   - response: 처리할 `Moya.Response`
    ///   - decodingType: 디코딩할 DTO 타입
    /// - Returns: 디코딩된 DTO 인스턴스. HTTP 통신 상태 코드가 200대가 아니거나, 디코디에 실패할 경우 에러를 던짐.
    ///
    /// `Moya.Provider`의 `request`결과가(콜백 함수의 매개변수) `.success` 인 경우 이를 처리하기 위해 사용.
    func handleSuccessCase<T: Decodable>(response: Moya.Response, decodingType: T.Type) throws -> T {
        // http 상태 코드 확인.
        let statusCode = response.statusCode
        guard (200...299).contains(statusCode) else {
            throw NetworkResultError.httpError(statusCode: statusCode)
        }
        
        // 지정된 DTO 형식으로 디코딩.
        guard let decodedDTO = try? JSONDecoder().decode(T.self, from: response.data) else {
            throw NetworkResultError.decodingFailed
        }
        
        return decodedDTO
    }
    
    /// `MoyaError`를 처리하여 `NetworkResultError` 타입을 반환하는 함수.
    /// - Parameter error: 처리할 `MoyaError`
    /// - Returns: `MoyaError`를 처리하여 반환할 `NetworkResultError`
    ///
    /// `Moya.Provider`의 `request`결과가(콜백 함수의 매개변수) `.failure` 인 경우 이를 처리하기 위해 사용.
    func handleFailureCase(moyaError: MoyaError) -> NetworkResultError {
        switch moyaError {
        case .underlying(let underlyingError, _):
            // underlying의 연관값 에러가 AFError가 아닌 경우 `.unknown` 반환
            guard let afError = underlyingError.asAFError else {
                return .unknown(underlyingError)
            }
            
            // AFError 중 .requestRetryFailed, .sessionTaskFailed 케이스만 처리.
            // 필요 시 다른 케이스들 추가.
            switch afError {
            case .requestRetryFailed(let retryError, _):
                if let urlError = retryError.asAFError?.underlyingError as? URLError {
                    return handleURLError(urlError)
                } else {
                    return .unknown(underlyingError)
                }
            case .sessionTaskFailed(let sessionError):
                if let urlError = sessionError.asAFError?.underlyingError as? URLError {
                    return handleURLError(urlError)
                } else {
                    return .unknown(underlyingError)
                }
            default:
                return .unknown(underlyingError)
            }
            
        // MoyaError.underlying 케이스가 아닌 경우
        default:
            return .unknown(moyaError)
        }
    }
    
    private func handleURLError(_ urlError: URLError) -> NetworkResultError {
        switch urlError.code {
        case .cancelled:
            return .networkCancelled
        case .notConnectedToInternet:
            return .notConnectedToInternet
        case .timedOut:
            return .timeOut
        default:
            return .unknownURLError(urlError)
        }
    }
    
}
