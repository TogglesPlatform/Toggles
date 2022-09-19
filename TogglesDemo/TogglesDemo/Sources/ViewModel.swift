//  ViewModel.swift

import Foundation
import Combine
import Toggles

class ViewModel {
    
    enum SetupConfiguration {
        case persistent
        case inMemory
        case immutable
    }
    
    let datasourceUrl: URL
    let remoteValueProvider: RemoteValueProvider
    let localValueProvider: OptionalValueProvider
    let cypherConfiguration: CypherConfiguration
    let manager: ToggleManager
    
    init(datasourceUrl: URL, setupConfiguration: SetupConfiguration, cypherConfiguration: CypherConfiguration) throws {
        self.datasourceUrl = datasourceUrl
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
    }
}
