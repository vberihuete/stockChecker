//
//  HistoryViewModel.swift
//  StockCheckerV2
//
//  Created by Vincent Berihuete Paulino on 08/10/2022.
//

import UIKit

final class HistoryViewModel {
    private let availabilityRepository = AvailabilityRepository()
    private let deviceRepository = DeviceRepository()
    private let speakInteractor = SpeakInteractor()
    private let watchDogInteractor = WatchDogInteractor(interval: 10)
    var elements: [CellDisplayModel] = []
    var reloadData: () -> Void = {}
    var cachedDevices: [String: Device] = [:]

    func viewDidLoad() {
        loadDevices { [weak self] in
            self?.loadResults()
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

    func clearFound() {
        availabilityRepository.clearAvailabilityHistory { [weak self] in
            self?.loadResults()
        }
    }
}

// MARK: private methods
private extension HistoryViewModel {
    enum Strings {
        static func availableFound(_ value: String, at store: String) -> String {
            "Found \(value) at \(store)"
        }
    }
    func updateData(history: [AvailabilityHistory]) {
        elements = []
        history.forEach { historyElement in
                elements.append(
                    .init(
                        title: cachedDevices[historyElement.model]?.description ?? historyElement.model,
                        subtitle: Strings.availableFound(
                            historyElement.date.smartFormat(),
                            at: historyElement.storeName
                        ),
                        distance: historyElement.distance,
                        available: true
                    )
                )
        }
        reloadData()
    }

    func loadResults() {
        availabilityRepository.getAvailabilityHistory { [weak self] history in
            self?.updateData(history: history)
        }
    }

    func loadDevices(completion: @escaping () -> Void) {
        let region = RegionSelectionView.currentSelectedRegion()
        deviceRepository.cachedDevices(region: region) { [weak self] devices in
            self?.cachedDevices = devices.reduce(into: [:]) { $0[$1.id] = $1 }
            completion()
        }
    }
}

extension Date {
    private static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .medium
        return formatter
    }()

    private static let timeFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .medium
        return formatter
    }()


    func smartFormat() -> String {
        if Calendar.current.isDateInToday(self) {
            return "Today \(Self.timeFormatter.string(from: self))"
        } else if Calendar.current.isDateInYesterday(self) {
            return "Yesterday \(Self.timeFormatter.string(from: self))"
        } else {
            return Self.dateFormatter.string(from: self)
        }
    }
}
