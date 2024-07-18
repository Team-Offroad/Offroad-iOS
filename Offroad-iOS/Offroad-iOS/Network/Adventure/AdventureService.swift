//
//  AdventureService.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 7/15/24.
//

import Foundation

import Moya

protocol AdventureServiceProtocol {
    func getAdventureInfo(category: String, completion: @escaping (NetworkResult<AdventureInfoResponseDTO>) -> ())
    func authenticateAdventure(adventureAuthDTO: AdventuresAuthenticationRequestDTO, completion: @escaping (NetworkResult<AdventuresAuthenticationResponseDTO>) -> ())
}

final class AdventureService: BaseService, AdventureServiceProtocol {
    let provider = MoyaProvider<AdventureAPI>(plugins: [MoyaPlugin()])

    func getAdventureInfo(category: String, completion: @escaping (NetworkResult<AdventureInfoResponseDTO>) -> ()) {
        provider.request(.getAdventureInfo(category: category)) { result in
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
    
    func authenticateAdventure(adventureAuthDTO: AdventuresAuthenticationRequestDTO, completion: @escaping (NetworkResult<AdventuresAuthenticationResponseDTO>) -> ()) {
        provider.request(.adventureAuthentication(adventureAuth: adventureAuthDTO)) { result in
            switch result {
            case .success(let response):
                let networkingResult: NetworkResult<AdventuresAuthenticationResponseDTO> = self.fetchNetworkResult(
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
