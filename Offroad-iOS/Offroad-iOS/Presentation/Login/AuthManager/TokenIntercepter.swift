//
//  TokenIntercepter.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 8/6/24.
//

import UIKit

import Alamofire

final class TokenInterceptor: RequestInterceptor {
    
    static let shared = TokenInterceptor()

    private init() {}

    func adapt(_ urlRequest: URLRequest, for session: Session, completion: @escaping (Result<URLRequest, Error>) -> Void) {
        print("adapt 진입")
        guard let urlString = Bundle.main.infoDictionary?["BASE_URL"] as? String else {
            completion(.success(urlRequest))
            return
        }
            
        guard urlRequest.url?.absoluteString.hasPrefix(urlString) == true,
              let accessToken = KeychainManager.shared.loadAccessToken()
        else {
            completion(.success(urlRequest))
            return
        }
        
        var newUrlRequest = urlRequest
        newUrlRequest.setValue("Bearer \(accessToken)", forHTTPHeaderField: "Authorization")
        completion(.success(newUrlRequest))
    }
    
    func retry(_ request: Request, for session: Session, dueTo error: Error, completion: @escaping (RetryResult) -> Void) {
        print("retry 진입")
        guard let response = request.task?.response as? HTTPURLResponse, response.statusCode == 401 else {
            completion(.doNotRetryWithError(error))
            return
        }
        
        NetworkService.shared.authService.postRefreshToken { response in
            switch response {
            case .success(let data):
                let accessToken = data?.data.accessToken ?? ""
                let refreshToken = data?.data.refreshToken ?? ""
                
                KeychainManager.shared.saveAccessToken(token: accessToken)
                KeychainManager.shared.saveRefreshToken(token: refreshToken)
                
                completion(.retry)
            case .unAuthentication:
                let loginViewController = LoginViewController()
                AppUtility.changeRootViewController(to: loginViewController)
                
            /// 다른 기기에서 로그인 후 회원을 탈퇴하면 현재 갖고 있는 `refreshToken`에 해당하는 계정이 사라지면서
            /// `HTTP` 상태 코드로 `401`이 아니라 `404`가 반환됨. 이에 대한 분기처리
            /// 응답값: `{"message":"해당 ID의 유저가 존재하지 않습니다.","customErrorCode":"NOT_EXISTS_MEMBER"}`
            case .apiArr(let dto):
                AppUtility.changeRootViewController(to: LoginViewController())
            default:
                completion(.doNotRetry)
            }
        }
    }
}
