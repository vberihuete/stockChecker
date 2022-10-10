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
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        return formatter
    }()

    var elements: [CellDisplayModel] = []
    var reloadData: () -> Void = {}
    var notifyAvailable: (Set<AvailabilityModel>) -> Void = { _ in }
    var updateInfo: (String) -> Void = { _ in }

    func viewDidLoad() {
        loadResults()
        scheduleFetch()
    }

    var numberOfSections: Int {
        1
    }

    func numberOfRows(in section: Int) -> Int {
        elements.count
    }

    func model(at indexPath: IndexPath) -> AvailableResultCell.Model? {
        guard let element = elements[safe: indexPath.row] else { return nil }
        return .init(
            title: element.title,
            subtitle: element.subtitle,
            indicatorColor: element.color,
            distanceTitle: element.distance
        )
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
        static func lastUpdated(_ value: String) -> String {
            "Last updated: \(value)"
        }
        static var stoppedWatchDog: String = "Stopped watch dog"
        static var startedWatchDog: String = "Started watch dog"
    }
    func updateData(stores: [FulfilmentStore]) {
        elements = []
        stores.forEach { store in
            store.parts.forEach { part in
                elements.append(
                    .init(
                        title: String(describing: part.model),
                        subtitle: store.storeName,
                        distance: store.storeDistance,
                        available: part.available)
                )
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
        let available: [AvailabilityHistory] = stores.flatMap { store in
            store.parts.compactMap { part in
                guard part.available else { return nil }
                return .init(model: part.model, storeName: store.storeName, distance: store.storeDistance, date: .init())
            }
        }
        guard available.isEmpty == false else { return }
        let availableModels = available.map(\.model)
        availableModels.forEach { model in
            speakInteractor.speak(Strings.isAvailable(.init(describing: model)))
        }
        repository.reportAvailability(historyModels: available)
        notifyAvailable(Set(availableModels))
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
            models: [.iPhone14ProMaxBlack128, .iPhone14ProMaxSilver128, .iPhone14ProMaxGold128],
            postCode: "E14 6UD"
        ) { [weak self, dateFormatter] result in
            guard case let .success(stores) = result else { return }
            let updatedDate = dateFormatter.string(from: Date())
            self?.updateInfo(Strings.lastUpdated(updatedDate))
            self?.updateData(stores: stores)
            self?.notifyAvailableIfNeeded(stores: stores)
        }
    }
}


// MARK: - Cell DisplayModel

struct CellDisplayModel {
    let title: String
    let subtitle: String
    let distance: String
    let available: Bool

    var color: UIColor {
        (available ? UIColor.green : UIColor.red).withAlphaComponent(0.7)
    }
}

public extension Collection {
    subscript (safe index: Index) -> Element? {
        return indices.contains(index) ? self[index] : nil
    }
}
