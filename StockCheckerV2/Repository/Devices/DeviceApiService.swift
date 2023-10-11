//
//  DevicesApiService.swift
//  StockCheckerV2
//
//  Created by Vincent Berihuete Paulino on 09/10/2023.
//

import Foundation

protocol DevicesApiServiceProtocol {
    func getDevices(
        completion: @escaping (Result<DeviceContainerDto, NetworkError>) -> Void
    )
}

final class DevicesApiService: DevicesApiServiceProtocol {
    private let networkClient: NetworkClientProtocol

    init(networkClient: NetworkClientProtocol) {
        self.networkClient = networkClient
    }

    func getDevices(
        completion: @escaping (Result<DeviceContainerDto, NetworkError>) -> Void
    ) {
        networkClient.request(
            url: "https://vberihuete.github.io/stockCheckerConfig/devices.json",
            method: .get,
            params: .query([:]),
            completion: completion
        )
    }
}
