//
//  AvailabilityStorageService.swift
//  StockCheckerV2
//
//  Created by Vincent Berihuete Paulino on 03/10/2022.
//

import Foundation

protocol AvailabilityStorageServiceProtocol {
    func persistAvailableModel(_ historyModels: [AvailabilityHistoryStoreDto], completion: @escaping () -> Void)
    func getAvailabilityHistory(completion: @escaping ([AvailabilityHistoryStoreDto]) -> Void)
    func clearHistory(completion: @escaping () -> Void)
}

final class AvailabilityStorageService: AvailabilityStorageServiceProtocol {
    private enum Constants {
        static let availableKey = "Available-array-key"
        static let historyLimit = 100
    }
    private let storageQueue = DispatchQueue(label: "AvailabilityStorageService-queue")

    func persistAvailableModel(_ historyModels: [AvailabilityHistoryStoreDto], completion: @escaping () -> Void) {
        storageQueue.async { [weak self] in
            guard let self = self else { return }
            var current = self.decode(data: UserDefaults.standard.data(forKey: Constants.availableKey))
            current = Array(current.prefix(Constants.historyLimit - historyModels.count))
            if current.isEmpty {
                current.append(contentsOf: historyModels)
            } else {
                current.insert(contentsOf: historyModels, at: 0)
            }
            UserDefaults.standard.set(self.encode(values: current), forKey: Constants.availableKey)
            DispatchQueue.main.async(execute: completion)
        }
    }

    func getAvailabilityHistory(completion: @escaping ([AvailabilityHistoryStoreDto]) -> Void) {
        storageQueue.async { [weak self] in
            let result = self?.decode(data: UserDefaults.standard.data(forKey: Constants.availableKey)) ?? []
            DispatchQueue.main.async {
                completion(result)
            }
        }
    }

    func clearHistory(completion: @escaping () -> Void) {
        storageQueue.async {
            UserDefaults.standard.removeObject(forKey: Constants.availableKey)
            DispatchQueue.main.async(execute: completion)
        }
    }
}

private extension AvailabilityStorageService {
    func encode(values: [AvailabilityHistoryStoreDto]) -> Data? {
        do {
            return try JSONEncoder().encode(values)
        } catch {
            assertionFailure(error.localizedDescription)
        }
        return nil
    }

    func decode(data: Data?) -> [AvailabilityHistoryStoreDto] {
        guard let data = data else {
            return []
        }

        guard let result = try? JSONDecoder().decode([AvailabilityHistoryStoreDto].self, from: data) else {
            return []
        }

        return result
    }
}
struct AvailabilityHistoryStoreDto: Codable, Hashable {
    let availableRawValue: String
    let storeName: String
    let distance: String
    let date: Date

    func toDomain() -> AvailabilityHistory? {
        guard let model = AvailabilityModel(rawValue: availableRawValue) else { return nil }
        return .init(model: model, storeName: storeName, distance: distance, date: date)
    }
}

extension AvailabilityHistoryStoreDto {
    init(object: AvailabilityHistory) {
        self.availableRawValue = object.model.rawValue
        self.storeName = object.storeName
        self.distance = object.distance
        self.date = object.date
    }
}
