//  DemoView.swift

import SwiftUI
import Toggles

struct DemoView: View {
    
    var viewModel: ViewModel
    
    var body: some View {
        TabView {
            TogglesView(manager: viewModel.manager, datasourceUrl: viewModel.datasourceUrl)
                .tabItem {
                    Label("Toggles", systemImage: "switch.2")
                }
            RemoteValueProviderView(provider: viewModel.remoteValueProvider, manager: viewModel.manager)
                .tabItem {
                    Label("Config update", systemImage: "wave.3.left")
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
        let datasourceUrl = Bundle.main.url(forResource: "DemoDatasource", withExtension: "json")!
        let cypherConfiguration = CypherConfiguration.chaChaPoly
        let viewModel = try! ViewModel(datasourceUrl: datasourceUrl,
                                       setupConfiguration: .inMemory,
                                       cypherConfiguration: cypherConfiguration)
        DemoView(viewModel: viewModel)
    }
}
