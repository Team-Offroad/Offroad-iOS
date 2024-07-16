//
//  PlaceService.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 7/15/24.
//

import Foundation

import Moya

protocol RegisteredPlaceServiceProtocol {
    func getAdventureInfo(
        requestDTO: RegisteredPlaceRequestDTO,
        completion: @escaping (NetworkResult<RegisteredPlaceResponseDTO>) -> ()
    )
}

final class RegisteredPlaceService: BaseService, RegisteredPlaceServiceProtocol {
    private let provider = MoyaProvider<PlaceAPI>(plugins: [MoyaPlugin()])

    func getAdventureInfo(
        requestDTO: RegisteredPlaceRequestDTO,
        completion: @escaping (NetworkResult<RegisteredPlaceResponseDTO>) -> ()
    ) {
        provider.request(.getRegisteredPlaces(requestDTO: requestDTO)) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<RegisteredPlaceResponseDTO> = self.fetchNetworkResult(
                    statusCode: response.statusCode,
                    data: response.data
                )
                completion(networkResult)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
}
