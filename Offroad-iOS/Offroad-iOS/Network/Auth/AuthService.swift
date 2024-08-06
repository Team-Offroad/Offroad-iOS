//
//  AuthService.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 7/15/24.
//

import Foundation

import Moya

protocol AuthServiceProtocol {
    func postSocialLogin(body: SocialLoginRequestDTO,
                          completion: @escaping (NetworkResult<SocialLoginResponseDTO>) -> ())
    func postRefreshToken(completion: @escaping (NetworkResult<RefreshTokenResponseDTO>) -> ())
}

final class AuthService: BaseService, AuthServiceProtocol {
    let provider = MoyaProvider<AuthAPI>.init(session: Session(interceptor: TokenInterceptor.shared), plugins: [MoyaPlugin()])

    func postSocialLogin(body: SocialLoginRequestDTO, completion: @escaping (NetworkResult<SocialLoginResponseDTO>) -> ()) {
        provider.request(.postSocialLogin(body: body)) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<SocialLoginResponseDTO> = self.fetchNetworkResult(
                    statusCode: response.statusCode,
                    data: response.data
                )
                completion(networkResult)
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func postRefreshToken(completion: @escaping ((NetworkResult<RefreshTokenResponseDTO>) -> ())) {
        provider.request(.postRefreshToken) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<RefreshTokenResponseDTO> = self.fetchNetworkResult(
                    statusCode: response.statusCode,
                    data: response.data
                )
                completion(networkResult)
            case .failure(let err):
                print(err)
            }
        }
    }
}
