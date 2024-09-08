//
//  AcquiredCharacterService.swift
//  Offroad-iOS
//
//  Created by  정지원 on 9/8/24.
//

import Foundation

import Moya

protocol AcquiredCharacterServiceProtocol {
    func getAcquiredCharacterInfo(completion: @escaping (NetworkResult<AcquiredCharacterResponseDTO>) -> ())
}

final class AcquiredCharacterService: BaseService, AcquiredCharacterServiceProtocol {
    let provider = MoyaProvider<AcquiredCharacterAPI>.init(session: Session(interceptor: TokenInterceptor.shared), plugins: [MoyaPlugin()])

    func getAcquiredCharacterInfo(completion: @escaping (NetworkResult<AcquiredCharacterResponseDTO>) -> ()) {
        provider.request(.getAcquiredCharacterInfo) { result in
            switch result {
            case .success(let response):
                print("===[\(response.statusCode)] \(response.data)===")
                let networkResult: NetworkResult<AcquiredCharacterResponseDTO> = self.fetchNetworkResult(
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


