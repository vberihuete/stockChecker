//
//  FulfilmentDto.swift
//  StockChecker
//
//  Created by Vincent Berihuete Paulino on 24/09/2022.
//

import Foundation

struct FulfilmentDto: Decodable {
    let body: FulfimentBodyDto
}

struct FulfimentBodyDto: Decodable {
    let content: FulfilmentContentDto
}

struct FulfilmentContentDto: Decodable {
    let pickupMessage: FulfilmentPickupMessageDto
}

struct FulfilmentPickupMessageDto: Decodable {
    let stores: [FulfilmentStoreDto]
}

struct FulfilmentStoreDto: Decodable {
    let storeName: String
    let storeDistanceWithUnit: String
    let rank: Int
    let partsAvailability: FulfilmentStorePartDtoContainer
}

struct FulfilmentStorePartDtoContainer: Decodable {
    let parts: [FulfilmentStorePartDto]

    struct DynamicKeys: CodingKey {
        var stringValue: String
        init?(stringValue: String) {
            self.stringValue = stringValue
        }
        var intValue: Int?
        init?(intValue: Int) {
            self.intValue = intValue
            self.stringValue = "\(intValue)"
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: DynamicKeys.self)
        var result = [FulfilmentStorePartDto]()

        for key in container.allKeys {
            guard let key = DynamicKeys(stringValue: key.stringValue) else { throw NetworkError.corruptData(description: "")}
            do {
                let decodedObject = try container.decode(FulfilmentStorePartDto.self, forKey: key)
                result.append(decodedObject)
            } catch {
                print(error)
            }
        }
        parts = result
    }
}
struct FulfilmentStorePartDto: Decodable {
    enum Pickup: String, Decodable, Equatable {
        case available
        case unavailable
        case ineligible
    }
    let pickupDisplay: Pickup
    let partNumber: String
}

// MARK: TO DOMAIN
extension FulfilmentStoreDto {
    func toDomain() -> FulfilmentStore {
        .init(
            storeName: storeName,
            storeDistance: storeDistanceWithUnit,
            rank: rank,
            parts: partsAvailability.parts.map {
                FulfilmentStore.FulfilmentStorePart(
                    available: $0.pickupDisplay == .available,
                    model: AvailabilityModel(rawValue: $0.partNumber) ?? .notMapped
                )
            }
        )
    }
}
