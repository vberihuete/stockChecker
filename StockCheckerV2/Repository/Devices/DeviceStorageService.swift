//
//  DeviceStorageService.swift
//  StockCheckerV2
//
//  Created by Vincent Berihuete Paulino on 09/10/2023.
//

import Foundation
typealias DeviceContainerStoreDto = DeviceContainerDto

protocol DeviceStorageServiceProtocol {
    func persist(storeDto: DeviceContainerStoreDto, completion: @escaping () -> Void)
    func cachedDevices(completion: @escaping (DeviceContainerStoreDto?) -> Void)
}

final class DeviceStorageService: DeviceStorageServiceProtocol {
    private enum Constants {
        static let deviceKey = "device-key"
        static let historyLimit = 100
    }
    private let storageQueue = DispatchQueue(label: "DeviceStorageService-queue")

    func persist(storeDto: DeviceContainerStoreDto, completion: @escaping () -> Void) {
        storageQueue.async {
            UserDefaults.standard.set(
                try? JSONEncoder().encode(storeDto),
                forKey: Constants.deviceKey
            )
            DispatchQueue.main.async(execute: completion)
        }
    }

    func cachedDevices(completion: @escaping (DeviceContainerStoreDto?) -> Void) {
        storageQueue.async {
            guard let data = UserDefaults.standard.value(forKey: Constants.deviceKey) as? Data else {
                return completion(nil)
            }
            let devices = try? JSONDecoder().decode(DeviceContainerStoreDto.self, from: data)
            DispatchQueue.main.async { completion(devices) }
        }
    }
}
