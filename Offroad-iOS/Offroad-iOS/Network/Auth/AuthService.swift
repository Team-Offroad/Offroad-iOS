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
    let provider = MoyaProvider<AuthAPI>(plugins: [MoyaPlugin()])

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
                let networkResult: NetworkResult<RefreshTokenResponseDTO> = self.fetchNetworkResult(
                    statusCode: err.response?.statusCode ?? Int(),
                    data: err.response?.data ?? Data()
                )
                completion(networkResult)
            }
        }
    }
}
