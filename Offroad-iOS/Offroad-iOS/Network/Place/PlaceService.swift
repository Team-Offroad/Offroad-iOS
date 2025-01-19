//
//  PlaceService.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 7/15/24.
//

import Foundation

import Moya

protocol RegisteredPlaceServiceProtocol {
    func getRegisteredPlace(
        requestDTO: RegisteredPlaceRequestDTO,
        completion: @escaping (NetworkResult<RegisteredPlaceResponseDTO>) -> ()
    )
    func getRegisteredMapPlaces(
        latitude: Double,
        longitude: Double,
        limit: Int,
        completion: @escaping (NetworkResult<RegisteredPlaceResponseDTO>) -> ()
    )
    func getRegisteredListPlaces(
        latitude: Double,
        longitude: Double,
        limit: Int,
        cursorDistance: Double?,
        completion: @escaping (NetworkResult<RegisteredPlaceResponseDTO>) -> ()
    )
}

final class RegisteredPlaceService: BaseService, RegisteredPlaceServiceProtocol {
    private let provider = MoyaProvider<PlaceAPI>.init(session: Session(interceptor: TokenInterceptor.shared), plugins: [MoyaPlugin()])

    func getRegisteredPlace(
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
                switch error {
                case .underlying(let error, let response):
                    print(error.localizedDescription)
                    if response == nil {
                        completion(.networkFail())
                    }
                default:
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    func getRegisteredMapPlaces(
        latitude: Double,
        longitude: Double,
        limit: Int,
        completion: @escaping (NetworkResult<RegisteredPlaceResponseDTO>) -> ()
    ) {
        provider.request(
            .getRegisteredMapPlaces(
                latitude: latitude,
                longitude: longitude,
                limit: limit
            )
        ) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<RegisteredPlaceResponseDTO> = self.fetchNetworkResult(
                    statusCode: response.statusCode,
                    data: response.data
                )
                completion(networkResult)
            case .failure(let error):
                print(error.localizedDescription)
                guard let response = error.response else {
                    completion(.networkFail(nil))
                    return
                }
                let networkResult: NetworkResult<RegisteredPlaceResponseDTO> = self.fetchNetworkResult(
                    statusCode: response.statusCode,
                    data: response.data
                )
                completion(networkResult)
            }
        }
    }
    
    func getRegisteredListPlaces(
        latitude: Double,
        longitude: Double,
        limit: Int,
        cursorDistance: Double? = nil,
        completion: @escaping (NetworkResult<RegisteredPlaceResponseDTO>) -> ()
    ) {
        provider.request(
            .getRegisteredListPlaces(
                latitude: latitude,
                longitude: longitude,
                limit: limit,
                cursorDistance: cursorDistance
            )
        ) { result in
            switch result {
            case .success(let response):
                let networkResult: NetworkResult<RegisteredPlaceResponseDTO> = self.fetchNetworkResult(
                    statusCode: response.statusCode,
                    data: response.data
                )
                completion(networkResult)
            case .failure(let error):
                guard let response = error.response else {
                    completion(.networkFail(nil))
                    return
                }
                let networkResult: NetworkResult<RegisteredPlaceResponseDTO> = self.fetchNetworkResult(
                    statusCode: response.statusCode,
                    data: response.data
                )
                completion(networkResult)
            }
        }
    }
}
