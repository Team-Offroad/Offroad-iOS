//
//  MinimumSupportedVersionService.swift
//  Offroad-iOS
//
//  Created by 김민성 on 5/9/25.
//

import Foundation

import Moya

final class MinimumSupportedVersionService: BaseService {
    private let provider = MoyaProvider<MinimumSupportedVersionAPI>.init(plugins: [MoyaPlugin()])
    
    func getMinimumSupportedVersion() async -> NetworkResult<MinimumSupportedVersionResponseDTO> {
        await withCheckedContinuation { continuation in
            provider.request(.getMinimumSupportedVersion, completion: { [weak self] result in
                guard let self else { return }
                switch result {
                case .success(let response):
                    let networkResult: NetworkResult<MinimumSupportedVersionResponseDTO> = self.fetchNetworkResult(
                        statusCode: response.statusCode,
                        data: response.data
                    )
                    continuation.resume(returning: networkResult)
                case .failure(let error):
                    print(error.localizedDescription)
                    if case .underlying(_, let response) = error, response == nil {
                        continuation.resume(returning: .networkFail())
                    }
                }
            })
        }
    }
}
