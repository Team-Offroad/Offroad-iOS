//
//  CharacterService.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 7/15/24.
//

import Foundation

import Moya

protocol CharacterServiceProtocol {
    func getCharacterInfo(completion: @escaping (NetworkResult<CharacterInfoResponseDTO>) -> ())
    func postChoosingCharacter(parameter: Int, completion: @escaping (NetworkResult<CharacterChoosingResponseDTO>) -> ())
}

final class CharacterService: BaseService, CharacterServiceProtocol {
    let provider = MoyaProvider<CharacterAPI>(plugins: [MoyaPlugin()])

    func getCharacterInfo(completion: @escaping (NetworkResult<CharacterInfoResponseDTO>) -> ()) {
        provider.request(.getCharacterInfo) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<CharacterInfoResponseDTO> = self.fetchNetworkResult(
                    statusCode: response.statusCode,
                    data: response.data
                )
                completion(networkResult)
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func postChoosingCharacter(parameter: Int, completion: @escaping (NetworkResult<CharacterChoosingResponseDTO>) -> ()) {
        provider.request(.postChoosingCharacter(characterID: parameter)) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<CharacterChoosingResponseDTO> = self.fetchNetworkResult(
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
