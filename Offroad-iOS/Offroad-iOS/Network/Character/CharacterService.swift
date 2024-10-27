//
//  CharacterService.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 7/15/24.
//

import Foundation

import Moya

protocol CharacterServiceProtocol {
    func getStartingCharacterList(completion: @escaping (NetworkResult<StartingCharacterResponseDTO>) -> ())
    func postChoosingCharacter(parameter: Int, completion: @escaping (NetworkResult<CharacterChoosingResponseDTO>) -> ())
    func getCharacterListInfo(completion: @escaping (NetworkResult<CharacterListResponseDTO>) -> ())
    func getCharacterDetail(characterId: Int, completion: @escaping (NetworkResult<CharacterDetailResponseDTO>) -> ())
    func getCharacterMotionList(characterId: Int, completion: @escaping (NetworkResult<CharacterMotionResponseDTO>) -> ())
}

final class CharacterService: BaseService, CharacterServiceProtocol {
    let provider = MoyaProvider<CharacterAPI>.init(session: Session(interceptor: TokenInterceptor.shared), plugins: [MoyaPlugin()])

    func getStartingCharacterList(completion: @escaping (NetworkResult<StartingCharacterResponseDTO>) -> ()) {
        provider.request(.getStartingCharacterList) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<StartingCharacterResponseDTO> = self.fetchNetworkResult(
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
    
    func getCharacterListInfo(completion: @escaping (NetworkResult<CharacterListResponseDTO>) -> ()) {
        provider.request(.getCharacterList) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<CharacterListResponseDTO> = self.fetchNetworkResult(
                    statusCode: response.statusCode,
                    data: response.data
                )
                completion(networkResult)
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func getCharacterDetail(characterId: Int, completion: @escaping (NetworkResult<CharacterDetailResponseDTO>) -> ()) {
        provider.request(.getCharacterDetail(characterId: characterId)) { result in
            switch result {
            case .success(let response):
                print("===[\(response.statusCode)] \(response.data)===")
                let networkResult: NetworkResult<CharacterDetailResponseDTO> = self.fetchNetworkResult(
                    statusCode: response.statusCode,
                    data: response.data
                )
                completion(networkResult)
            case .failure(let err):
                print(err)
            }
        }
    }
    
    func getCharacterMotionList(characterId: Int, completion: @escaping (NetworkResult<CharacterMotionResponseDTO>) -> ()) {
        provider.request(.getCharacterMotionList(characterId: characterId)) { result in
            switch result {
            case .success(let response):
                print("===[\(response.statusCode)] \(response.data)===")
                let networkResult: NetworkResult<CharacterMotionResponseDTO> = self.fetchNetworkResult(
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
