//
//  ProfileService.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 7/15/24.
//

import Foundation

import Moya

protocol ProfileServiceProtocol {
    func updateProfile(body: ProfileUpdateRequestDTO, completion: @escaping (NetworkResult<ProfileUpdateResponseDTO>) -> ())
    func postDeleteAccount(body: DeleteAccountRequestDTO, completion: @escaping (NetworkResult<DeleteAccountResponseDTO>) -> ())
    func patchMarketingConsent(body: MarketingConsentRequestDTO, completion: @escaping (NetworkResult<MarketingConsentResponseDTO>) -> ())
    func getUserInfo(completion: @escaping (NetworkResult<UserInfoResponseDTO>) -> ())
}

final class ProfileService: BaseService, ProfileServiceProtocol {
    let provider = MoyaProvider<ProfileAPI>.init(session: Session(interceptor: TokenInterceptor.shared), plugins: [MoyaPlugin()])
    
    func updateProfile(body: ProfileUpdateRequestDTO, completion: @escaping (NetworkResult<ProfileUpdateResponseDTO>) -> ()) {
        provider.request(.updateProfile(body: body)) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<ProfileUpdateResponseDTO> = self.fetchNetworkResult(
                    statusCode: response.statusCode,
                    data: response.data
                )
                completion(networkResult)
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func postDeleteAccount(body: DeleteAccountRequestDTO, completion: @escaping (NetworkResult<DeleteAccountResponseDTO>) -> ()) {
        provider.request(.postDeleteAccount(body: body)) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<DeleteAccountResponseDTO> = self.fetchNetworkResult(
                    statusCode: response.statusCode,
                    data: response.data
                )
                completion(networkResult)
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func patchMarketingConsent(body: MarketingConsentRequestDTO, completion: @escaping (NetworkResult<MarketingConsentResponseDTO>) -> ()) {
        
        provider.request(.patchMarketingConsent(body: body)) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<MarketingConsentResponseDTO> = self.fetchNetworkResult(
                    statusCode: response.statusCode,
                    data: response.data
                )
                completion(networkResult)
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func getUserInfo(completion: @escaping (NetworkResult<UserInfoResponseDTO>) -> ()) {
        provider.request(.getUserInfo) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<UserInfoResponseDTO> = self.fetchNetworkResult(
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
