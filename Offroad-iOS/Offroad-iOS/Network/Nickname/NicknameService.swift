//
//  NicknameService.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 7/15/24.
//

import Foundation

import Moya

protocol NicknameServiceProtocol {
    func checkNicknameDuplicate(completion: @escaping (NetworkResult<NicknameCheckResponseDTO>) -> ())
}

final class NicknameService: BaseService, NicknameServiceProtocol {
    func checkNicknameDuplicate(completion: @escaping (NetworkResult<NicknameCheckResponseDTO>) -> ()) {
        <#code#>
    }
    
    let provider = MoyaProvider<NicknameAPI>(plugins: [MoyaPlugin()])

    func getAdventureInfo(completion: @escaping (NetworkResult<NicknameCheckResponseDTO>) -> ()) {
        provider.request(.checkNicknameDuplicate) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<NicknameCheckResponseDTO> = self.fetchNetworkResult(
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

