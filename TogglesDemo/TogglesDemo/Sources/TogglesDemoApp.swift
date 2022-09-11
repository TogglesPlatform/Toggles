//  TogglesDemoApp.swift

import Foundation
import SwiftUI
import Toggles

@main
struct TogglesDemoApp: App {
    
    let viewModel: ViewModel
    let key = "AyUcYw-qWebYF-z0nWZ4"
    
    init() {
        let datasourceUrl = Bundle.main.url(forResource: "DemoDatasource", withExtension: "json")!
        let decryptionConfiguration = DecryptionConfiguration(algorithm: .chaCha20Poly1305, key: key)
        viewModel = try! ViewModel(datasourceUrl: datasourceUrl, decryptionConfiguration: decryptionConfiguration)
    }
    
    var body: some Scene {
        WindowGroup {
            TabView {
                TogglesView(manager: viewModel.manager, datasourceUrl: viewModel.datasourceUrl)
                    .tabItem {
                        Label("Toggles", systemImage: "switch.2")
                    }
                RemoteValueProviderView(provider: viewModel.remoteValueProvider, manager: viewModel.manager)
                    .tabItem {
                        Label("Publishing", systemImage: "wave.3.left")
                    }
                
            }
        }
    }
}
