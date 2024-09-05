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
    func authenticateQRAdventure(adventureAuthDTO: AdventuresQRAuthenticationRequestDTO, completion: @escaping (NetworkResult<AdventuresQRAuthenticationResponseDTO>) -> ())
    func authenticatePlaceAdventure(adventureAuthDTO: AdventuresPlaceAuthenticationRequestDTO, completion: @escaping (NetworkResult<AdventuresPlaceAuthenticationResponseDTO>) -> ())
}

final class AdventureService: BaseService, AdventureServiceProtocol {
    
    let provider = MoyaProvider<AdventureAPI>.init(session: Session(interceptor: TokenInterceptor.shared), plugins: [MoyaPlugin()])

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
    
    func authenticateQRAdventure(adventureAuthDTO: AdventuresQRAuthenticationRequestDTO, completion: @escaping (NetworkResult<AdventuresQRAuthenticationResponseDTO>) -> ()) {
        provider.request(.adventureQRAuthentication(adventureQRAuth: adventureAuthDTO)) { result in
            switch result {
            case .success(let response):
                let networkingResult: NetworkResult<AdventuresQRAuthenticationResponseDTO> = self.fetchNetworkResult(
                    statusCode: response.statusCode,
                    data: response.data
                )
                completion(networkingResult)
            default:
                return
            }
        }
    }
    
    func authenticatePlaceAdventure(adventureAuthDTO: AdventuresPlaceAuthenticationRequestDTO, completion: @escaping (NetworkResult<AdventuresPlaceAuthenticationResponseDTO>) -> ()) {
        provider.request(.adventurePlaceAuthentication(adventurePlaceAuth: adventureAuthDTO)) { result in
            switch result {
            case .success(let response):
                let networkingResult: NetworkResult<AdventuresPlaceAuthenticationResponseDTO> = self.fetchNetworkResult(
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
