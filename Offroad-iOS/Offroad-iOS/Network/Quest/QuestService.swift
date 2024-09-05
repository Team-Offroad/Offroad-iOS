//
//  QuestService.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 7/15/24.
//

import Foundation

import Moya

protocol QuestServiceProtocol {
    func getQuestInfo(completion: @escaping (NetworkResult<QuestInfoResponseDTO>) -> ())
}

final class QuestService: BaseService, QuestServiceProtocol {
    let provider = MoyaProvider<QuestAPI>.init(session: Session(interceptor: TokenInterceptor.shared), plugins: [MoyaPlugin()])

    func getQuestInfo(completion: @escaping (NetworkResult<QuestInfoResponseDTO>) -> ()) {
        provider.request(.getQuestInfo) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<QuestInfoResponseDTO> = self.fetchNetworkResult(
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
