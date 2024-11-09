//
//  QuestListService.swift
//  Offroad-iOS
//
//  Created by 김민성 on 8/27/24.
//

import Foundation

import Moya

protocol QuestListServiceProtocol {
    func getQuestList(isActive: Bool, cursor: Int, size: Int, completion: @escaping (NetworkResult<QuestListResponseDTO>) -> ())
}

final class QuestListService: BaseService, QuestListServiceProtocol {
    let provider = MoyaProvider<QuestListAPI>.init(session: Session(interceptor: TokenInterceptor.shared), plugins: [MoyaPlugin()])
    
    func getQuestList(isActive: Bool, cursor: Int, size: Int, completion: @escaping (NetworkResult<QuestListResponseDTO>) -> ()) {
        provider.request(.getQuestList(isActive: isActive, cursor: cursor, size: size)) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<QuestListResponseDTO> = self.fetchNetworkResult(
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
