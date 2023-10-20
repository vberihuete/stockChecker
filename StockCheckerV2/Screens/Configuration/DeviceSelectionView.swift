//
//  DeviceSelectionView.swift
//  StockCheckerV2
//
//  Created by Vincent Berihuete Paulino on 11/10/2023.
//

import SwiftUI

class DeviceSelectionViewModel: ObservableObject {
    @Published var devices: [Device] = []
    @Published var selectedDevices: [String: Device] = [:]
    static let selectedDevicesKey = "device.selection.view.selected"
    private let deviceRepository = DeviceRepository()

    func fetchDevices() {
        let region = RegionSelectionView.currentSelectedRegion()
        deviceRepository.cachedDevices(region: region) { [weak self] devices in
            self?.devices = devices
            self?.updateSelected()
            let cachedDevices = devices
            self?.deviceRepository.getUpdatedDevices(region: region) { result in
                guard case let .success(devices) = result else { return }
                self?.devices = devices
                if devices != cachedDevices {
                    self?.updateSelected()
                }
            }
        }
    }

    func onAppear() {
        fetchDevices()
        subscribeToNotification()
    }

    func onDisappear() {
        saveSelectedDevices()
        unsubscribeToNotification()
    }

    func updateSelected() {
        guard !devices.isEmpty else { return }
        let selectedIds = UserDefaults.standard.array(forKey: Self.selectedDevicesKey) as? [String] ?? []
        let devicesKeyed = devices.reduce(into: [:]) { $0[$1.id] = $1 }
        selectedDevices = selectedIds.reduce(into: [:]) { $0[$1] = devicesKeyed[$1] }
    }
    
    func saveSelectedDevices() {
        UserDefaults.standard.set(Array(selectedDevices.keys), forKey: Self.selectedDevicesKey)
    }

    func toggleSelection(device: Device) {
        guard selectedDevices.removeValue(forKey: device.id) == nil else { return }
        selectedDevices[device.id] = device
    }

    private func subscribeToNotification() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(handleRegionChange),
            name: .regionChanged,
            object: nil
        )
    }

    private func unsubscribeToNotification() {
        NotificationCenter.default.removeObserver(self, name: .regionChanged, object: nil)
    }

    @objc private func handleRegionChange() {
        selectedDevices = [:]
        saveSelectedDevices()
        fetchDevices()
    }
}

struct DeviceSelectionView: View {
    @StateObject private var viewModel = DeviceSelectionViewModel()

    var body: some View {
        VStack {
            if viewModel.devices.isEmpty {
                HStack(alignment: .center) {
                    Spacer()
                    ProgressView("Fetching Devices...")
                        .onAppear {
                            viewModel.fetchDevices()
                        }
                    Spacer()
                }
            } else {
                Text("Device Selection")
                    .font(.headline)
                    .padding()

                ForEach(viewModel.devices, id: \.self) { device in
                    HStack {
                        Text(device.description)
                        Spacer()
                        Toggle("", isOn: Binding(
                            get: { viewModel.selectedDevices[device.id] != nil },
                            set: { newValue in
                                viewModel.toggleSelection(device: device)
                            }
                        ))
                        .labelsHidden()
                        .toggleStyle(SwitchToggleStyle(tint: .blue))
                    }
                    Divider()
                }
            }
            Spacer()
        }
        .onAppear {
            viewModel.onAppear()
        }
        .onDisappear {
            viewModel.onDisappear()
        }
    }
}


struct DeviceSelectionView_Previews: PreviewProvider {
    static var previews: some View {
        DeviceSelectionView()
    }
}
