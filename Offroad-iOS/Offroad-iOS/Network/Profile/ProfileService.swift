//
//  ProfileService.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 7/15/24.
//

import Foundation

import Moya

protocol ProfileServiceProtocol {
    func updateProfile(body: ProfileUpdateRequestDTO, completion: @escaping (NetworkResult<ProfileUpdateRequestDTO>) -> ())
}

final class ProfileService: BaseService, ProfileServiceProtocol {
    let provider = MoyaProvider<ProfileAPI>(plugins: [MoyaPlugin()])
    
    func updateProfile(body: ProfileUpdateRequestDTO, completion: @escaping (NetworkResult<ProfileUpdateRequestDTO>) -> ()) {
        provider.request(.updateProfile(body: body)) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<ProfileUpdateRequestDTO> = self.fetchNetworkResult(
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
