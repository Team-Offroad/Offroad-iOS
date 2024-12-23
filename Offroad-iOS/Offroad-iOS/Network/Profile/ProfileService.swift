//
//  ProfileService.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 7/15/24.
//

import Foundation

import Moya

protocol ProfileServiceProtocol {
    func patchUpdateProfile(body: ProfileUpdateRequestDTO, completion: @escaping (NetworkResult<CharacterChoosingResponseDTO>) -> ())
    func postDeleteAccount(body: DeleteAccountRequestDTO, completion: @escaping (NetworkResult<DeleteAccountResponseDTO>) -> ())
    func patchMarketingConsent(body: MarketingConsentRequestDTO, completion: @escaping (NetworkResult<Any>) -> ())
    func getUserInfo(completion: @escaping (NetworkResult<UserInfoResponseDTO>) -> ())
}

final class ProfileService: BaseService, ProfileServiceProtocol {
    let provider = MoyaProvider<ProfileAPI>.init(session: Session(interceptor: TokenInterceptor.shared), plugins: [MoyaPlugin()])
    
    func patchUpdateProfile(body: ProfileUpdateRequestDTO, completion: @escaping (NetworkResult<CharacterChoosingResponseDTO>) -> ()) {
        provider.request(.patchUpdateProfile(body: body)) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<CharacterChoosingResponseDTO> = self.fetchNetworkResult(
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
    
    func patchMarketingConsent(body: MarketingConsentRequestDTO, completion: @escaping (NetworkResult<Any>) -> ()) {
        
        provider.request(.patchMarketingConsent(body: body)) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<Any> = self.fetchNetworkResult(
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
