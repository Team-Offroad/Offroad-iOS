//
//  CharacterChatService.swift
//  Offroad-iOS
//
//  Created by 김민성 on 11/14/24.
//

import Foundation

import Moya

protocol CharacterChatServiceProtocol {
    func postChat(
        characterId: Int?,
        body: CharacterChatPostRequestDTO,
        completion: @escaping (NetworkResult<CharacterChatPostResponseDTO>) -> Void
    )
    func getChatLog(
        characterId: Int?,
        limit: Int,
        cursor: Int?,
        completion: @escaping (NetworkResult<CharacterChatGetResponseDTO>) -> Void
    )
    func patchChatRead(characterId: Int?, completion: @escaping (NetworkResult<Any>) -> Void)
    func getLastChatInfo(completion: @escaping (NetworkResult<CharacterChatReadGetResponseDTO>) -> Void)
}

final class CharacterChatService: BaseService, CharacterChatServiceProtocol {
    
    let provider = MoyaProvider<CharacterChatAPI>.init(session: Session(interceptor: TokenInterceptor.shared), plugins: [MoyaPlugin()])
    
    func postChat(characterId: Int? = nil, body: CharacterChatPostRequestDTO, completion: @escaping (NetworkResult<CharacterChatPostResponseDTO>) -> Void) {
        provider.request(.postChat(characterId: characterId, body: body)) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<CharacterChatPostResponseDTO> = self.fetchNetworkResult(
                    statusCode: response.statusCode,
                    data: response.data
                )
                completion(networkResult)
            case .failure(let error):
                let networkResult: NetworkResult<CharacterChatPostResponseDTO> = self.fetchNetworkResult(
                    statusCode: error.response?.statusCode ?? 0,
                    data: error.response?.data ?? Data()
                )
                completion(networkResult)
            }
        }
    }
    
    func getChatLog(characterId: Int? = nil, limit: Int, cursor: Int? = nil, completion: @escaping (NetworkResult<CharacterChatGetResponseDTO>) -> Void) {
        provider.request(
            CharacterChatAPI.getChatLog(characterId: characterId, limit: limit, cursor: cursor)
        ) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<CharacterChatGetResponseDTO> = self.fetchNetworkResult(
                    statusCode: response.statusCode,
                    data: response.data
                )
                completion(networkResult)
            case .failure(let error):
                print(error.localizedDescription)
                guard let response = error.response else { return }
                let networkResult: NetworkResult<CharacterChatGetResponseDTO> = self.fetchNetworkResult(
                    statusCode: response.statusCode,
                    data: response.data
                )
                completion(networkResult)
            }
        }
    }
    
    func patchChatRead(characterId: Int? = nil, completion: @escaping (NetworkResult<Any>) -> Void) {
        provider.request(.patchChatRead(characterId: characterId)) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<Any> = self.fetchNetworkResult(
                    statusCode: response.statusCode,
                    data: response.data
                )
                completion(networkResult)
            case .failure(let error):
                guard let response = error.response else { return }
                let networkResult: NetworkResult<Any> = self.fetchNetworkResult(
                    statusCode: response.statusCode,
                    data: response.data
                )
                completion(networkResult)
            }
        }
    }
    
    func getLastChatInfo(completion: @escaping (NetworkResult<CharacterChatReadGetResponseDTO>) -> Void) {
        provider.request(.getLastChatInfo) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<CharacterChatReadGetResponseDTO> = self.fetchNetworkResult<CharacterChatReadGetResponseDTO>(
                    statusCode: response.statusCode,
                    data: response.data
                )
                completion(networkResult)
            case .failure(let error):
                guard let response = error.response else { return }
                let networkResult: NetworkResult<CharacterChatReadGetResponseDTO> = self.fetchNetworkResult(
                    statusCode: response.statusCode,
                    data: response.data
                )
                completion(networkResult)
            }
        }
    }
}
