//
//  SoundDistanceView.swift
//  StockCheckerV2
//
//  Created by Vincent Berihuete Paulino on 14/10/2024.
//

import SwiftUI
import Combine

struct SoundDistanceView: View {
    @State private var soundOn: Bool = !UserDefaults.standard.bool(forKey: Self.soundOffKey)
    @State private var distanceValue: Double = UserDefaults.standard.value(
        forKey: Self.distanceKey
    ) as? Double ?? Self.maxDistance
    let regions = Region.allCases.map(\.rawValue)
    static let soundOffKey = "configuration.sound"
    static let distanceKey = "configuration.distance"
    static let maxDistance = 1_000.0
    static let minDistance = 5.0

    var body: some View {
        VStack() {
            HStack() {
                Text("Distance").font(.headline)
                Spacer()
                Slider(
                    value: $distanceValue,
                    in: Self.minDistance...Self.maxDistance,
                    step: 5,
                    label: {Text("other")},
                    minimumValueLabel: {
                        Text("Min")
                            .font(.caption)
                            .foregroundColor(.gray)
                    },
                    maximumValueLabel: {
                        Text(maxLabelText())
                            .font(.caption)
                            .foregroundColor(.gray)
                    },
                    onEditingChanged: { isEditing in
                        guard isEditing == false else { return }
                        updateDistance(distanceValue)
                    }
                )
            }
            HStack() {
                Text("Sound on").font(.headline)
                Spacer()
                Toggle("", isOn: $soundOn)
                    .onChange(of: soundOn, perform: { newValue in
                        updateSoundConfig(newValue)
                    })
                    .labelsHidden()
                    .toggleStyle(SwitchToggleStyle(tint: .blue))
                    .padding(.init(top: 0, leading: 0, bottom: 0, trailing: 2))
            }
        }
    }

    func updateSoundConfig(_ value: Bool) {
        let soundOff = !value
        UserDefaults.standard.setValue(soundOff, forKey: Self.soundOffKey)
        if soundOff {
            SpeakInteractor().stop()
        }
    }

    func updateDistance(_ value: Double) {
        UserDefaults.standard.setValue(value, forKey: Self.distanceKey)
    }

    func maxLabelText() -> String {
        if distanceValue >= (Self.maxDistance - 10) {
            return "Max"
        } else {
            return "\(Int(distanceValue))"
        }
    }
}


struct SoundDistanceView_Previews: PreviewProvider {
    static var previews: some View {
        SoundDistanceView()
    }
}
