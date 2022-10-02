//  DemoView.swift

import SwiftUI
import Toggles

struct DemoView: View {
    
    var viewModel: DemoConfiguration
    
    var body: some View {
        TabView {
            TogglesView(manager: viewModel.manager, datasourceUrl: viewModel.datasourceUrl)
                .tabItem {
                    Label("Toggles", systemImage: "switch.2")
                }
            RemoteValueProviderView(provider: viewModel.remoteValueProvider, manager: viewModel.manager)
                .tabItem {
                    Label("Config update", systemImage: "icloud.and.arrow.down")
                }
            ToggleAccessorView(accessor: ToggleAccessor(manager: viewModel.manager))
                .tabItem {
                    Label("Accessors", systemImage: "snowflake")
                }
            ToggleObservablesView(manager: viewModel.manager)
                .tabItem {
                    Label("Observables", systemImage: "slowmo")
                }
        }
    }
}

struct DemoView_Previews: PreviewProvider {
    static var previews: some View {
        let cipherConfiguration = CipherConfiguration.chaChaPoly
        let demoConfiguration = try! DemoConfiguration(setupConfiguration: .inMemory,
                                                       demoDatasource: .default,
                                                       cipherConfiguration: cipherConfiguration)
        DemoView(viewModel: demoConfiguration)
    }
}
