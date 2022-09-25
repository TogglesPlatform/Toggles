//  TogglesDemoApp.swift

import Foundation
import SwiftUI
import Toggles

@main
struct TogglesDemoApp: App {
    
    
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
                DemoView(viewModel: setupDemoConfiguration())
            }
        }
    }
    
    private func setupDemoConfiguration() -> DemoConfiguration {
        try! DemoConfiguration(setupConfiguration: setupConfiguration,
                               demoDatasource: demoDatasource,
                               cypherConfiguration: CypherConfiguration.chaChaPoly)
    }
}
