//
//  EmblemService.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 7/15/24.
//

import Foundation

import Moya

protocol EmblemServiceProtocol {
    func getEmblemInfo(completion: @escaping (NetworkResult<EmblemInfoResponseDTO>) -> ())
    func patchUserEmblem(parameter: String, completion: @escaping (NetworkResult<ChangeEmblemResponseDTO>) -> ())
}

final class EmblemService: BaseService, EmblemServiceProtocol {
    let provider = MoyaProvider<EmblemAPI>(plugins: [MoyaPlugin()])

    func getEmblemInfo(completion: @escaping (NetworkResult<EmblemInfoResponseDTO>) -> ()) {
        provider.request(.getEmblemInfo) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<EmblemInfoResponseDTO> = self.fetchNetworkResult(
                    statusCode: response.statusCode,
                    data: response.data
                )
                completion(networkResult)
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func patchUserEmblem(parameter: String, completion: @escaping (NetworkResult<ChangeEmblemResponseDTO>) -> ()) {
        provider.request(.patchUserEmblem(emBlemCode: parameter)) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<ChangeEmblemResponseDTO> = self.fetchNetworkResult(
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
