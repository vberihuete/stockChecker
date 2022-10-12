//
//  ConfigViewModel.swift
//  StockCheckerV2
//
//  Created by Vincent Berihuete Paulino on 12/10/2022.
//

import Foundation

final class ConfigViewModel {
    enum Action: Equatable {
        case reload
    }
    private let didRequestAction: (Action) -> Void
    private let configRepository = ConfigRepository()

    init(
        completion: @escaping (Action) -> Void
    ) {
        self.didRequestAction = completion
    }
}
