//
//  ConfigurationView.swift
//  StockCheckerV2
//
//  Created by Vincent Berihuete Paulino on 01/10/2023.
//

import SwiftUI

extension Notification.Name {
    static let configurationTextChanged = Notification.Name("ConfigurationTextChanged")
}


struct ConfigurationView: View {
    static let zipCodeKey = "configuration.view.zipcode"
    @State private var configurationText: String = ""

    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading) {
                    Text("Please provide the zip code that you would like the watch dog to search for")
                        .font(.headline)
                    TextField("Enter zip code", text: $configurationText)
                        .padding(.vertical)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .textContentType(.postalCode)
                    Text("Select from the list bellow which devices you want the watch dog to search")
                        .font(.headline)
                    DeviceSelectionView()
                        .padding(.horizontal, 2)
                    Spacer()
                }
            }
            .padding()
            .navigationTitle("Configuration")
            .onDisappear {
                saveConfiguration()
            }
            .onAppear {
                loadConfiguration()
            }
            .navigationTitle("Configuration")
        }
    }

    private func saveConfiguration() {
        UserDefaults.standard.set(configurationText, forKey: Self.zipCodeKey)
        postTextChangeNotification()
    }

    private func loadConfiguration() {
        if let savedText = UserDefaults.standard.string(forKey: Self.zipCodeKey) {
            configurationText = savedText
        }
    }

    private func postTextChangeNotification() {
        NotificationCenter.default.post(name: .configurationTextChanged, object: nil)
    }
}

struct ConfigurationView_Previews: PreviewProvider {
    static var previews: some View {
        ConfigurationView()
    }
}
