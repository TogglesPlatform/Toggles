//  TogglesDemoApp.swift

import Foundation
import SwiftUI
import Toggles

@main
struct TogglesDemoApp: App {
    
    private enum SetupStage {
        case start
        case configurationSelected
        case datasourceSelected
    }
    
    @State private var setupStage: SetupStage = .start
    @State private var setupConfiguration: DemoConfiguration.SetupConfiguration!
    @State private var demoDatasource: DemoConfiguration.DemoDatasource!
    
    init() {}
    
    var body: some Scene {
        WindowGroup {
            switch setupStage {
            case .start:
                Text("")
                    .alert("Select setup", isPresented: .constant(true)) {
                        Button("Persistent") {
                            setupConfiguration = .persistent
                            setupStage = .configurationSelected
                        }
                        Button("In Memory") {
                            setupConfiguration = .inMemory
                            setupStage = .configurationSelected
                        }
                        Button("Immutable") {
                            setupConfiguration = .immutable
                            setupStage = .configurationSelected
                        }
                    }
            case .configurationSelected:
                Text("")
                    .alert("Select datasource", isPresented: .constant(true)) {
                        Button("Default") {
                            demoDatasource = .default
                            setupStage = .datasourceSelected
                        }
                        Button("Huge (10K entries)") {
                            demoDatasource = .huge
                            setupStage = .datasourceSelected
                        }
                    }
            case .datasourceSelected:
                DemoView(viewModel: setupDemoConfiguration())
            }
        }
    }
    
    private func setupDemoConfiguration() -> DemoConfiguration {
        try! DemoConfiguration(setupConfiguration: setupConfiguration,
                               demoDatasource: demoDatasource,
                               cipherConfiguration: CipherConfiguration.chaChaPoly)
    }
}
