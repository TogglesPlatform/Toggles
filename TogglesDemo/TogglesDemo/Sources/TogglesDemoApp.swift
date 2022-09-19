//  TogglesDemoApp.swift

import Foundation
import SwiftUI
import Toggles

@main
struct TogglesDemoApp: App {
    
    @State private var setupConfiguration: ViewModel.SetupConfiguration!
    
    init() {}
    
    var body: some Scene {
        WindowGroup {
            if setupConfiguration == nil {
                Text("")
                    .alert("Select setup", isPresented: .constant(true)) {
                        Button("Persistent") {
                            setupConfiguration = .persistent
                        }
                        Button("In Memory") {
                            setupConfiguration = .inMemory
                        }
                        Button("Immutable") {
                            setupConfiguration = .immutable
                        }
                    }
            }
            else {
                DemoView(viewModel: setupViewModel())
            }
        }
    }
    
    private func setupViewModel() -> ViewModel {
        let datasourceUrl = Bundle.main.url(forResource: "DemoDatasource", withExtension: "json")!
        let cypherConfiguration = CypherConfiguration.chaChaPoly
        return try! ViewModel(datasourceUrl: datasourceUrl,
                              setupConfiguration: setupConfiguration,
                              cypherConfiguration: cypherConfiguration)
    }
}
