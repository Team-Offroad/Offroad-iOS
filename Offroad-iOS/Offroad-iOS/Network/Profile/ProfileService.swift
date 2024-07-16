//
//  ProfileService.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 7/15/24.
//

import Foundation

import Moya

protocol ProfileServiceProtocol {
    func updateProfile(nickname: String, year: Int, month: Int, day: Int, gender: String, completion: @escaping (NetworkResult<ProfileUpdateRequestDTO>) -> ())
}

final class ProfileService: BaseService, ProfileServiceProtocol {    

    let provider = MoyaProvider<ProfileAPI>(plugins: [MoyaPlugin()])
    
    func updateProfile(
        nickname: String,
        year: Int,
        month: Int,
        day: Int,
        gender: String,
        completion: @escaping (NetworkResult<ProfileUpdateRequestDTO>) -> ()
    ) {
        
        provider.request(.updateProfile(nickname: nickname, year: year, month: month, day: day, gender: gender)) { result in
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
