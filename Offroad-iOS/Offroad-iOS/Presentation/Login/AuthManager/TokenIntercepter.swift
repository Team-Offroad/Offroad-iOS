//
//  TokenIntercepter.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 8/6/24.
//

import Foundation

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
            default:
                completion(.doNotRetry)
            }
        }
    }
}
