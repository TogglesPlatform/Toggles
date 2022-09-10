//  TogglesDemoApp.swift

import Foundation
import SwiftUI
import Toggles

@main
struct TogglesDemoApp: App {
    
    let viewModel: ViewModel
    
    init() {
        viewModel = try! ViewModel(datasourceUrl: Bundle.main.url(forResource: "DemoDatasource", withExtension: "json")!)
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
