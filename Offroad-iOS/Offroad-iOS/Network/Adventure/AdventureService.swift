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
            case .failure(let error):
                print(error.localizedDescription)
                switch error {
                case .underlying(let error, let response):
                    print(error.localizedDescription)
                    if response == nil {
                        completion(.networkFail())
                    }
                default:
                    return
                }
            }
        }
    }
    
    // 바로 위의 authenticatePlaceAdventure 메서드를 async/await 코드로 변환
    func authenticatePlaceAdventure(
        adventureAuthDTO: AdventuresPlaceAuthenticationRequestDTO
    ) async throws -> AdventuresPlaceAuthenticationResultData {
        let api = AdventureAPI.adventurePlaceAuthentication(adventurePlaceAuth: adventureAuthDTO)
        return try await withCheckedThrowingContinuation { continuation in
            provider.request(api) { result in
                switch result {
                case .success(let moyaResponse):
                    do {
                        let decodedDTO = try NetworkResultHandler().handleSuccessCase(
                            response: moyaResponse,
                            decodingType: AdventuresPlaceAuthenticationResponseDTO.self
                        )
                        continuation.resume(returning: decodedDTO.data)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                case .failure(let moyaError):
                    let errorToThrow = NetworkResultHandler().handleFailureCase(moyaError: moyaError)
                    continuation.resume(throwing: errorToThrow)
                }
            }
        }
        
    }
    
}
