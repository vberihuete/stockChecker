//
//  WatchDogInteractor.swift
//  StockCheckerV2
//
//  Created by Vincent Berihuete Paulino on 02/10/2022.
//

import Foundation

final class WatchDogInteractor {
    private let interval: TimeInterval
    private var watchDog: Timer?

    init(
        interval: TimeInterval = 5
    ) {
        self.interval = interval
    }

    func start() {
        watchDog = Timer.scheduledTimer(withTimeInterval: interval, repeats: true) { [weak self] _ in
            self?.action()
        }
    }

    func stop() {
        watchDog?.invalidate()
        watchDog = nil
    }

    var isActive: Bool {
        watchDog != nil
    }

    var action: () -> Void = {}
}
