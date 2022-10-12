//
//  ConfigStorageService.swift
//  StockCheckerV2
//
//  Created by Vincent Berihuete Paulino on 12/10/2022.
//

import Foundation

protocol ConfigStorageServiceProtocol: AnyObject {
    var postCode: String? { get set }
}

final class ConfigStorageService: ConfigStorageServiceProtocol {
    private static let postCodeKey = "config-post-code"

    var postCode: String? {
        set {
            UserDefaults.standard.set(newValue, forKey: Self.postCodeKey)
        }
        get {
            UserDefaults.standard.value(forKey: Self.postCodeKey) as? String
        }
    }
}
