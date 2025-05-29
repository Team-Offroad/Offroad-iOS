//
//  NetworkResultError.swift
//  Offroad-iOS
//
//  Created by 김민성 on 5/29/25.
//

import Foundation

/// 네트워크 통신 시 발생할 수 있는 에러
enum NetworkResultError: LocalizedError {
    
    /// `HTTP` 통신 후 상태 코드가 400~599인 경우 에러로 간주.
    case httpError(statusCode: Int)
    
    /// 응답값이 정해진 DTO로 디코딩되지 않음.
    case decodingFailed
    
    /// 네트워크 통신 실패
    case networkFailed
    
    /// 네트워크 Timtout
    case networkTimeout
    
    var errorDescription: String? {
        switch self {
        case .httpError(let statusCode):
            switch statusCode {
            case 200...299:
                assertionFailure("상태 코드가 200번대인 경우는 에러가 아닙니다.")
                return "상태 코드가 200번대인 경우는 에러가 아닙니다."
            case 400: return "400(Bad Request) 올바르지 않은 요청입니다."
            case 401: return "401(Unauthorized) 인증 실패(Unauthenticated)"
            case 403: return "403(Forbidden) 인가 실패(Unauthorized)"
            case 404: return "404(Not Found) 요청된 리소스를 찾을 수 없습니다."
            case 500: return "500(Internal Server Error) 서버 내부 에러"
            case 502: return "502(Bad Gateway)"
            default: return "코드에서 명시되지 않은 기타 HTTP 응답 상태 에러. 상태 코드: \(statusCode)"
            }
        case .decodingFailed:
            return "서버의 응답값(Body)을 지정한 DTO로 디코딩하는 데에 실패했습니다. 서버의 응답값 형식 또는 DTO를 확인하세요."
        case .networkFailed:
            return "네트워크 통신에 실패했습니다. 인터넷 연결 상태를 확인하세요."
        case .networkTimeout:
            return "네트워크 통신 타임아웃."
        }
    }
    
}
