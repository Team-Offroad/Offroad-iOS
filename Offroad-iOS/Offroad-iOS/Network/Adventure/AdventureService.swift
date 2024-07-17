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
    func authenticateAdventure(adventureAuthDTO: AdventuresAuthenticationRequestDTO, completion: @escaping (NetworkResult<AdventuresAuthenticationRequestDTO>) -> ())
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
    
    func authenticateAdventure(adventureAuthDTO: AdventuresAuthenticationRequestDTO, completion: @escaping (NetworkResult<AdventuresAuthenticationRequestDTO>) -> ()) {
        provider.request(.adventureAuthentication(adventureAuth: adventureAuthDTO)) { result in
            switch result {
            case .success(let response):
                let networkingResult: NetworkResult<AdventuresAuthenticationRequestDTO> = self.fetchNetworkResult(
                    statusCode: response.statusCode,
                    data: response.data
                )
                completion(networkingResult)
            default:
                return
            }
        }
    }
}
