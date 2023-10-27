//
//  DeviceRepository.swift
//  StockCheckerV2
//
//  Created by Vincent Berihuete Paulino on 09/10/2023.
//

import Foundation

protocol DeviceRepositoryProtocol {
    func cachedDevices(region: Region, completion: @escaping ([Device]) -> Void)
    func getUpdatedDevices(region: Region, completion: @escaping (Result<[Device], NetworkError>) -> Void)
    func cachedOrUpdatedDevices(region: Region, completion: @escaping (Result<[Device], NetworkError>) -> Void)
}


final class DeviceRepository: DeviceRepositoryProtocol {
    private let apiService: DevicesApiServiceProtocol
    private let storageService: DeviceStorageServiceProtocol

    init(apiService: DevicesApiServiceProtocol, storageService: DeviceStorageServiceProtocol) {
        self.apiService = apiService
        self.storageService = storageService
    }

    convenience init() {
        self.init(
            apiService: DevicesApiService(networkClient: NetworkClient()),
            storageService: DeviceStorageService()
        )
    }

    func cachedDevices(region: Region, completion: @escaping ([Device]) -> Void) {
        storageService.cachedDevices { containerStoreDto in
            let domain = containerStoreDto?.toDomain()
            completion(domain?.devices(for: region) ?? [])
        }
    }

    func getUpdatedDevices(region: Region, completion: @escaping (Result<[Device], NetworkError>) -> Void) {
        apiService.getDevices { [storageService] result in
            switch result {
            case let .success(value):
                storageService.persist(storeDto: value) {
                    let domain = value.toDomain()
                    completion(.success(domain.devices(for: region)))
                }
            case let .failure(error):
                completion(.failure(error))
            }
        }
    }

    func cachedOrUpdatedDevices(region: Region, completion: @escaping (Result<[Device], NetworkError>) -> Void) {
        cachedDevices(region: region) { [weak self] devices in
            if devices.isEmpty {
                self?.getUpdatedDevices(region: region, completion: completion)
            } else {
                completion(.success(devices))
            }
        }
    }
}

private extension DeviceContainer {
    func devices(for region: StockCheckerV2.Region) -> [Device] {
        switch region {
        case .us:
            return self.region.us
        case .uk:
            return self.region.uk
        case .ca:
            return self.region.ca
        }
    }
}
