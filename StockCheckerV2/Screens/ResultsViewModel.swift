//
//  ResultsViewModel.swift
//  StockCheckerV2
//
//  Created by Vincent Berihuete Paulino on 02/10/2022.
//

import Foundation
import UIKit

final class ResultsViewModel {
    private let availabilityRepository = AvailabilityRepository()
    private let deviceRepository = DeviceRepository()
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
    var notifyAvailable: (Set<Device>) -> Void = { _ in }
    var updateInfo: (String) -> Void = { _ in }
    var zipCode: String? {
        UserDefaults.standard.string(forKey: ConfigurationView.zipCodeKey)
    }

    var observedDevices: [Device] {
        let keys = UserDefaults.standard.array(forKey: DeviceSelectionViewModel.selectedDevicesKey) as? [String] ?? []
        let selected = keys.compactMap { cachedDevices[$0] }
        return selected.isEmpty ? Array(cachedDevices.values) : selected
    }

    var cachedDevices: [String: Device] = [:]
    func viewDidLoad() {
        loadDevices { [weak self] in
            self?.loadResults()
            self?.scheduleFetch()
        }
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
            speakInteractor.stop()
            speakInteractor.speak(Strings.stoppedWatchDog)
            updateInfo(Strings.watchDogIsStopped)
        } else {
            speakInteractor.stop()
            watchDogInteractor.start()
            speakInteractor.speak(Strings.startedWatchDog)
            updateInfo(Strings.watchDogIsSearching)
        }
    }

    func configurationChanged() {
        speakInteractor.stop()
        updateData(stores: [])
        loadResults()
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
        static var watchDogIsStopped = "Watch dog is not searching - tap any row to search"
        static var watchDogIsSearching = "Watch dog is searching - tap any row to stop"
    }
    func updateData(stores: [FulfilmentStore]) {
        elements = []
        stores.forEach { store in
            store.parts.forEach { part in
                elements.append(
                    .init(
                        title: cachedDevices[part.model]?.description ?? part.model,
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
        let availableModels = available.compactMap { cachedDevices[$0.model] }
        availableModels.forEach { model in
            speakInteractor.speak(Strings.isAvailable(.init(describing: model.description)))
        }
        availabilityRepository.reportAvailability(historyModels: available)
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
        guard let zipCode, !cachedDevices.isEmpty else { return }
        availabilityRepository.getAvailability(
            models: observedDevices,
            postCode: zipCode
        ) { [weak self, dateFormatter] result in
            guard case let .success(stores) = result else { return }
            let updatedDate = dateFormatter.string(from: Date())
            self?.updateInfo(Strings.lastUpdated(updatedDate))
            self?.updateData(stores: stores)
            self?.notifyAvailableIfNeeded(stores: stores)
        }
    }

    func loadDevices(completion: @escaping () -> Void) {
        let region = RegionSelectionView.currentSelectedRegion()
        deviceRepository.cachedOrUpdatedDevices(region: region) { [weak self] result in
            guard case let .success(devices) =  result else { return completion() }
            self?.cachedDevices = devices.reduce(into: [:]) { $0[$1.id] = $1 }
            completion()
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
