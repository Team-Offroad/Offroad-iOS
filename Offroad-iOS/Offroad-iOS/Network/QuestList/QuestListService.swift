//
//  QuestListService.swift
//  Offroad-iOS
//
//  Created by 김민성 on 8/27/24.
//

import Foundation

import Moya

final class QuestListService: BaseService {
    let provider = MoyaProvider<QuestListAPI>.init(session: Session(interceptor: TokenInterceptor.shared), plugins: [MoyaPlugin()])
    
    func getQuestList(isActive: Bool, cursor: Int, size: Int, completion: @escaping (Result<QuestListResponseDTO, NetworkResultError>) -> ()) {
        let api = QuestListAPI.getQuestList(isActive: isActive, cursor: cursor, size: size)
        let resultHandler = NetworkResultHandler()
        provider.request(api) { result in
            switch result {
            case .success(let response):
                do {
                    let decodedData = try resultHandler.handleSuccessCase(
                        response: response,
                        decodingType: QuestListResponseDTO.self
                    )
                    completion(.success(decodedData))
                } catch let error as NetworkResultError {
                    completion(.failure(error))
                } catch {
                    completion(.failure(.unknown(error)))
                }
            case .failure(let error):
                completion(.failure(resultHandler.handleFailureCase(moyaError: error))) 
            }
        }
    }
    
    func getQuestList(isActive: Bool, cursor: Int, size: Int) async throws -> QuestListResponseDTO {
        let api = QuestListAPI.getQuestList(isActive: isActive, cursor: cursor, size: size)
        let resultHandler = NetworkResultHandler()
        return try await withCheckedThrowingContinuation { continuation in
            provider.request(api) { result in
                switch result {
                case .success(let response):
                    do {
                        let decodedDTO = try resultHandler.handleSuccessCase(
                            response: response,
                            decodingType: QuestListResponseDTO.self
                        )
                        continuation.resume(returning: decodedDTO)
                    } catch {
                        continuation.resume(throwing: error)
                    }
                case .failure(let error):
                    continuation.resume(throwing: resultHandler.handleFailureCase(moyaError: error))
                }
            }
        }
    }
}
