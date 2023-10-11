//
//  AvailabilityHistory.swift
//  StockCheckerV2
//
//  Created by Vincent Berihuete Paulino on 05/10/2022.
//

import Foundation

struct AvailabilityHistory: Hashable {
    let model: String
    let storeName: String
    let distance: String
    let date: Date
}
