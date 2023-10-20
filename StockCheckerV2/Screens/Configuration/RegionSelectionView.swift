//
//  RegionSelectionView.swift
//  StockCheckerV2
//
//  Created by Vincent Berihuete Paulino on 19/10/2023.
//

import SwiftUI
import Combine

struct RegionSelectionView: View {
    @Binding var isPresented: Bool

    @State private var selectedRegion: String = UserDefaults.standard.string(
        forKey: Self.selectedRegionKey
    ) ?? Region.us.rawValue
    let regions = Region.allCases.map(\.rawValue)
    static let selectedRegionKey = "region.selection.view.selected"

    var body: some View {
        HStack() {
            Text("Selected Region")
                .font(.headline)
            Spacer()
            Picker("", selection: $selectedRegion) {
                ForEach(regions, id: \.self) { region in
                    Text(region)
                }
            }
            .pickerStyle(.segmented)
        }
        .onReceive(Just(selectedRegion)) { _ in
            saveSelectedRegion()
        }
    }

    static func currentSelectedRegion() -> Region {
        guard
            let regionString = UserDefaults.standard.string(forKey: Self.selectedRegionKey),
            let region = Region(rawValue: regionString)
        else {
            return .us
        }
        return region
    }

    private func saveSelectedRegion() {
        let current = Self.currentSelectedRegion()
        UserDefaults.standard.set(selectedRegion, forKey: Self.selectedRegionKey)
        if current != Self.currentSelectedRegion() {
            NotificationCenter.default.post(name: .regionChanged, object: nil)
        }
    }
}
