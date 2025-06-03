//
//  PlaceService.swift
//  Offroad-iOS
//
//  Created by 조혜린 on 7/15/24.
//

import CoreLocation
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
        at coordinate: CLLocationCoordinate2D,
        limit: Int,
        cursorDistance: Double?
    ) async throws -> [PlaceModel]
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
    
    // 아직 사용되지 않는 함수임.
    func getRegisteredMapPlaces(
        at coordinate: CLLocationCoordinate2D,
        limit: Int
    ) async throws -> [PlaceModel] {
        let api = PlaceAPI.getRegisteredMapPlaces(
            latitude: coordinate.latitude,
            longitude: coordinate.longitude,
            limit: limit
        )
        return try await fetchPlaces(using: api)
    }
    
    func getRegisteredListPlaces(
        at coordinate: CLLocationCoordinate2D,
        limit: Int,
        cursorDistance: Double? = nil
    ) async throws -> [PlaceModel] {
        let api = PlaceAPI.getRegisteredListPlaces(
            latitude: coordinate.latitude,
            longitude: coordinate.longitude,
            limit: limit,
            cursorDistance: cursorDistance
        )
        return try await fetchPlaces(using: api)
    }
    
    /// 주어진 api로 오브에 등록된 장소 목록을 서버에 요청해 비동기적으로 반환하는 함수.
    /// - Parameter api: 서버 요청에 사용할 API. `PlaceAPI` 타입.(`Moya`의 `TargetType` 프로토콜을 준수함.)
    /// - Returns: 요청한 장소 목록.`[PlaceModel]` 타입.
    private func fetchPlaces(using api: PlaceAPI) async throws -> [PlaceModel] {
        try await withCheckedThrowingContinuation { continuation in
            provider.request(api) { result in
                switch result {
                case .success(let response):
                    // http 상태 코드 확인.
                    let statusCode = response.statusCode
                    guard (200...299).contains(statusCode) else {
                        continuation.resume(throwing: NetworkResultError.httpError(statusCode: statusCode))
                        return
                    }
                    
                    // 지정된 DTO 형식으로 디코딩.
                    guard let decodedDTO = try? JSONDecoder().decode(
                        RegisteredPlaceResponseDTO.self,
                        from: response.data
                    ) else {
                        continuation.resume(throwing: NetworkResultError.decodingFailed)
                        return
                    }
                    
                    // 디코딩된 데이터를 최종적으로 반환하는 타입으로 변환.
                    do {
                        let decodedDTOList = decodedDTO.data.places
                        let places = try decodedDTOList.map { try PlaceModel($0) }
                        continuation.resume(returning: places)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                case .failure(let error):
                    switch error {
                    case .underlying(let underlyingError, _):
                        if let urlError = underlyingError as? URLError {
                            switch urlError.code {
                            case .notConnectedToInternet, .cannotConnectToHost:
                                continuation.resume(throwing: NetworkResultError.networkFailed)
                            case .timedOut:
                                continuation.resume(throwing: NetworkResultError.networkTimeout)
                            default:
                                continuation.resume(throwing: error)
                            }
                        }
                    default:
                        continuation.resume(throwing: error)
                    }
                }
            }
        }
    }
    
}
