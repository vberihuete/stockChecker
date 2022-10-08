//
//  AvailabilityRepository.swift
//  StockChecker
//
//  Created by Vincent Berihuete Paulino on 23/09/2022.
//

import Foundation

protocol AvailabilityRepositoryProtocol {
    func getAvailability(
        models: [AvailabilityModel],
        postCode: String,
        completion: @escaping (Result<[FulfilmentStore], NetworkError>) -> Void
    )

    func reportAvailability(historyModels: [AvailabilityHistory])
}

final class AvailabilityRepository: AvailabilityRepositoryProtocol {
    private let apiService: AvailabilityApiServiceProtocol
    private let storageService: AvailabilityStorageServiceProtocol

    init(
        apiService: AvailabilityApiServiceProtocol,
        storageService: AvailabilityStorageServiceProtocol
    ) {
        self.apiService = apiService
        self.storageService = storageService
    }

    convenience init() {
        self.init(
            apiService: AvailabilityApiService(networkClient: NetworkClient()),
            storageService: AvailabilityStorageService()
        )
    }

    func getAvailability(
        models: [AvailabilityModel],
        postCode: String,
        completion: @escaping (Result<[FulfilmentStore], NetworkError>) -> Void
    ) {
        apiService.getAvailability(models: models.map(\.rawValue), postCode: postCode) {
            completion($0.map { $0.body.content.pickupMessage.stores.map { $0.toDomain() }} )
        }
    }

    func reportAvailability(historyModels: [AvailabilityHistory]) {
        storageService.persistAvailableModel(
            historyModels.map { AvailabilityHistoryStoreDto(object: $0) },
            completion: {}
        )
    }

    func getAvailabilityHistory(completion: @escaping ([AvailabilityHistory]) -> Void) {
        storageService.getAvailabilityHistory { completion($0.compactMap { $0.toDomain() }) }
    }

    func clearAvailabilityHistory(completion: @escaping () -> Void) {
        storageService.clearHistory(completion: completion)
    }
}
