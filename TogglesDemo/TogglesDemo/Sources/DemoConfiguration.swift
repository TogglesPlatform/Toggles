//  DemoConfiguration.swift

import Foundation
import Combine
import Toggles

class DemoConfiguration {
    
    enum SetupConfiguration {
        case persistent
        case inMemory
        case immutable
    }
    
    enum DemoDatasource {
        case `default`
        case huge
    }
    
    let datasourceUrl: URL
    let remoteValueProvider: RemoteValueProvider
    let localValueProvider: OptionalValueProvider
    let cypherConfiguration: CypherConfiguration
    let manager: ToggleManager
    
    init(setupConfiguration: SetupConfiguration,
         demoDatasource: DemoDatasource,
         cypherConfiguration: CypherConfiguration) throws {
        switch demoDatasource {
        case .default:
            self.datasourceUrl = Bundle.main.url(forResource: "DemoDatasource", withExtension: "json")!
        case .huge:
            self.datasourceUrl = Bundle.main.url(forResource: "10kEntriesDemoDatasource", withExtension: "json")!
        }
        self.remoteValueProvider = try RemoteValueProvider(jsonURL: datasourceUrl)
        self.localValueProvider = try LocalValueProvider(jsonURL: datasourceUrl)
        self.cypherConfiguration = cypherConfiguration
        switch setupConfiguration {
        case .persistent:
            self.manager = try ToggleManager(mutableValueProvider: PersistentValueProvider(userDefaults: .standard),
                                             valueProviders: [remoteValueProvider, localValueProvider],
                                             datasourceUrl: datasourceUrl,
                                             cypherConfiguration: cypherConfiguration)
        case .inMemory:
            self.manager = try ToggleManager(mutableValueProvider: InMemoryValueProvider(),
                                             valueProviders: [remoteValueProvider, localValueProvider],
                                             datasourceUrl: datasourceUrl,
                                             cypherConfiguration: cypherConfiguration)
        case .immutable:
            self.manager = try ToggleManager(valueProviders: [remoteValueProvider, localValueProvider],
                                             datasourceUrl: datasourceUrl,
                                             cypherConfiguration: cypherConfiguration)
        }
        self.manager.verbose = true
    }
}
