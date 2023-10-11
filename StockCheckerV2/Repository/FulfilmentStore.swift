//
//  FulfilmentStore.swift
//  StockChecker
//
//  Created by Vincent Berihuete Paulino on 26/09/2022.
//

import Foundation

struct FulfilmentStore: Equatable {
    let storeName: String
    let storeDistance: String
    let rank: Int
    let parts: [FulfilmentStorePart]

    struct FulfilmentStorePart: Equatable {
        let available: Bool
        let model: String
    }
}
