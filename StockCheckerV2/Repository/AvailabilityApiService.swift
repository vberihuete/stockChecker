//
//  AvailabilityApiService.swift
//  StockChecker
//
//  Created by Vincent Berihuete Paulino on 23/09/2022.
//

import Foundation

protocol AvailabilityApiServiceProtocol {
    func getAvailability(
        models: [String],
        postCode: String,
        completion: @escaping (Result<FulfilmentDto, NetworkError>) -> Void
    )
}

final class AvailabilityApiService: AvailabilityApiServiceProtocol {
    private let networkClient: NetworkClientProtocol

    init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
    }

    func getAvailability(
        models: [String],
        postCode: String,
        completion: @escaping (Result<FulfilmentDto, NetworkError>) -> Void
    ) {
        var params: [String: String] = [
            "pl": "true",
            "mts.0": "regular",
            "mts.1": "compact",
            "location": postCode
        ]
        models.enumerated().forEach { index, model in
            params["parts.\(index)"] = model
        }
        let region = RegionSelectionView.currentSelectedRegion().rawValue.lowercased()
        networkClient.request(
            url: "https://www.apple.com/\(region)/shop/fulfillment-messages",
            method: .get,
            params: .query(params),
            completion: completion
        )
    }
}
