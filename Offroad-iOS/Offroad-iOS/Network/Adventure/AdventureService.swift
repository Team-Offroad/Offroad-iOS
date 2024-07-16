//
//  AdventureService.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 7/15/24.
//

import Foundation

import Moya

protocol AdventureServiceProtocol {
    func getAdventureInfo(completion: @escaping (NetworkResult<AdventureInfoResponseDTO>) -> ())
}

final class AdventureService: BaseService, AdventureServiceProtocol {
    let provider = MoyaProvider<AdventureAPI>(plugins: [MoyaPlugin()])

    func getAdventureInfo(completion: @escaping (NetworkResult<AdventureInfoResponseDTO>) -> ()) {
        provider.request(.getAdventureInfo) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<AdventureInfoResponseDTO> = self.fetchNetworkResult(
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
