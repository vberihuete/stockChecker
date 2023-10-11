//
//  Device.swift
//  StockCheckerV2
//
//  Created by Vincent Berihuete Paulino on 09/10/2023.
//

import Foundation

struct DeviceContainer: Hashable {
    struct Region: Hashable {
        let uk: [Device]
        let us: [Device]
    }
    let region: Region
}

struct Device: Hashable {
    let id: String
    let name: String
    let color: String
    let capacity: String

    var description: String {
        "\(name) \(color) \(capacity)"
    }
}
