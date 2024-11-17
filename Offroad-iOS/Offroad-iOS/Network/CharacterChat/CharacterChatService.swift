//
//  CharacterChatService.swift
//  Offroad-iOS
//
//  Created by 김민성 on 11/14/24.
//

import Foundation

import Moya

protocol CharacterChatServiceProtocol {
    func postChat(body: CharacterChatPostRequestDTO, completion: @escaping (NetworkResult<CharacterChatPostResponseDTO>) -> Void)
    func getChatLog(completion: @escaping (NetworkResult<CharacterChatGetResponseDTO>) -> Void)
}

final class CharacterChatService: BaseService, CharacterChatServiceProtocol {
    
    let provider = MoyaProvider<CharacterChatAPI>.init(session: Session(interceptor: TokenInterceptor.shared), plugins: [MoyaPlugin()])
    
    func postChat(body: CharacterChatPostRequestDTO, completion: @escaping (NetworkResult<CharacterChatPostResponseDTO>) -> Void) {
        provider.request(.postChat(body: body)) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<CharacterChatPostResponseDTO> = self.fetchNetworkResult(
                    statusCode: response.statusCode,
                    data: response.data
                )
                completion(networkResult)
            case .failure(let error):
                print(error.localizedDescription)
                switch error {
                case .underlying(let erorr, let response):
                    print(error.localizedDescription)
                    if response == nil {
                        completion(.networkFail)
                    }
                default:
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func getChatLog(completion: @escaping (NetworkResult<CharacterChatGetResponseDTO>) -> Void) {
        provider.request(.getChatLog) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<CharacterChatGetResponseDTO> = self.fetchNetworkResult(
                    statusCode: response.statusCode,
                    data: response.data
                )
                completion(networkResult)
            case .failure(let error):
                print(error.localizedDescription)
                switch error {
                case .underlying(let error, let response):
                    print(error.localizedDescription)
                    if response == nil {
                        completion(.networkFail)
                    }
                default:
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    
}
