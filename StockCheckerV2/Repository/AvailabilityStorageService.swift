//
//  AvailabilityStorageService.swift
//  StockCheckerV2
//
//  Created by Vincent Berihuete Paulino on 03/10/2022.
//

import Foundation

protocol AvailabilityStorageServiceProtocol {
    func persistAvailableModel(_ models: Set<AvailabilityModel>, completion: @escaping () -> Void) 
    func getAvailabilityHistory(completion: @escaping ([AvailabilityHistoryStoreDto]) -> Void)
}

final class AvailabilityStorageService: AvailabilityStorageServiceProtocol {
    private enum Constants {
        static let availableKey = "Available-array-key"
    }

    func persistAvailableModel(_ models: Set<AvailabilityModel>, completion: @escaping () -> Void) {
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            var current = self.decode(data: UserDefaults.standard.data(forKey: Constants.availableKey))
            let historyModels: [AvailabilityHistoryStoreDto] = models.map { .init(availableRawValue: $0.rawValue, date: .init())}
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
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            let result = self?.decode(data: UserDefaults.standard.data(forKey: Constants.availableKey)) ?? []
            DispatchQueue.main.async {
                completion(result)
            }
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
struct AvailabilityHistoryStoreDto: Codable {
    let availableRawValue: String
    let date: Date

    func toDomain() -> AvailabilityHistory? {
        guard let model = AvailabilityModel(rawValue: availableRawValue) else { return nil }
        return .init(model: model, date: date)
    }
}
