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
}

final class AvailabilityRepository: AvailabilityRepositoryProtocol {
    private let apiService: AvailabilityApiServiceProtocol

    init(
        apiService: AvailabilityApiServiceProtocol
    ) {
        self.apiService = apiService
    }

    convenience init() {
        self.init(apiService: AvailabilityApiService(networkClient: NetworkClient()))
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
}
