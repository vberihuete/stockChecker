//
//  ResultsViewModel.swift
//  StockCheckerV2
//
//  Created by Vincent Berihuete Paulino on 02/10/2022.
//

import Foundation
import UIKit

final class ResultsViewModel {
    private let repository = AvailabilityRepository()
    private let speakInteractor = SpeakInteractor()
    private let watchDogInteractor = WatchDogInteractor(interval: 10)

    var elements: [CellDisplayModel] = []
    var reloadData: () -> Void = {}
    var notifyAvailable: (Set<AvailabilityModel>) -> Void = { _ in }

    func viewDidLoad() {
        loadResults()
        scheduleFetch()
        repository.getAvailabilityHistory { history in
            print("here's the history: ")
            history.forEach { element in
                print(element)
            }
        }
    }

    var numberOfSections: Int {
        1
    }

    func numberOfRows(in section: Int) -> Int {
        elements.count
    }

    func model(at indexPath: IndexPath) -> CellDisplayModel {
        elements[indexPath.row]
    }

    func toggleWatchDog() {
        if watchDogInteractor.isActive {
            watchDogInteractor.stop()
            speakInteractor.speak(Strings.stoppedWatchDog)
        } else {
            watchDogInteractor.start()
            speakInteractor.speak(Strings.startedWatchDog)
        }
    }
}

// MARK: private methods
private extension ResultsViewModel {
    enum Strings {
        static func isAvailable(_ value: String) -> String {
            "\(value) is available"
        }
        static var stoppedWatchDog: String = "Stopped watch dog"
        static var startedWatchDog: String = "Started watch dog"
    }
    func updateData(stores: [FulfilmentStore]) {
        elements = []
        stores.forEach { store in
            store.parts.forEach { part in
                elements.append(.init(title: String(describing: part.model), subtitle: store.storeName, available: part.available))
            }
        }
        elements.sort { lhs, rhs in
            lhs.title > rhs.title
        }
        elements.sort { lhs, rhs in
            lhs.available && !rhs.available
        }
        reloadData()
    }

    func notifyAvailableIfNeeded(stores: [FulfilmentStore]) {
        let available = Set(stores.flatMap { $0.parts.compactMap { $0.available ? $0.model : nil } })
        guard available.isEmpty == false else { return }
        available.forEach { model in
            speakInteractor.speak(Strings.isAvailable(.init(describing: model)))
        }
        repository.reportAvailability(models: available)
        notifyAvailable(available)
    }

    func scheduleFetch() {
        watchDogInteractor.action = { [weak self] in
            self?.loadResults()
        }
        watchDogInteractor.start()
        speakInteractor.speak(Strings.startedWatchDog)
    }

    func loadResults() {
        repository.getAvailability(
            models: [.iPhone14ProMaxBlack128, .iPhone14ProMaxSilver128, .iPhone14ProMaxGold128, .iPhone14Blue128],
            postCode: "E14 6UD"
        ) { [weak self] result in
            guard case let .success(stores) = result else { return }
            print("updating \(Date())")
            self?.updateData(stores: stores)
            self?.notifyAvailableIfNeeded(stores: stores)
        }
    }
}


// MARK: - Cell DisplayModel

struct CellDisplayModel {
    let title: String
    let subtitle: String
    let available: Bool

    var color: UIColor {
        (available ? UIColor.green : UIColor.red).withAlphaComponent(0.2)
    }
}
