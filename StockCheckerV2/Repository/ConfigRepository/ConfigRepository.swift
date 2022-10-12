//
//  ConfigRepository.swift
//  StockCheckerV2
//
//  Created by Vincent Berihuete Paulino on 12/10/2022.
//

import Foundation

protocol ConfigRepositoryProtocol {

}

final class ConfigRepository: ConfigRepositoryProtocol {
    private let storage: ConfigStorageServiceProtocol

    init(
        storage: ConfigStorageServiceProtocol
    ) {
        self.storage = storage
    }

    convenience init() {
        self.init(storage: ConfigStorageService())
    }

    func getPostCode() -> String? {
        storage.postCode
    }

    func updatePostCode(_ value: String) {
        storage.postCode = value
    }
}
