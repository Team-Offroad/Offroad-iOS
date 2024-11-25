//
//  NetworkResult.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 7/15/24.
//

import Foundation

enum NetworkResult<T> {
    case success(T?)                // 서버 통신 성공했을 때 (200, 201, 204)
    case requestErr                 // 올바르지 않은 요청 에러 발생했을 때 (400)
    case unAuthentication           // 인증 실패 응답 받았을 때 (401)
    case unAuthorization            // 인가 실패 응답 받았을 때 (403)
    case apiArr                     // 존재하지 않는 api를 호출했을 때 (404)
    case pathErr                    // 경로 에러 발생했을 때 (405)
    case registerErr                // 데이터 등록 오류가 발생했을 때 (409)
    case networkFail                // 네트워크 연결 실패했을 때
    case serverErr                // 서버에서 에러가 발생했을 때 (500대)
    case decodeErr                  // 데이터는 받아왔으나 DTO 형식으로 decode가 되지 않을 때
}
