//  ViewModel.swift

import Foundation
import Combine
import Toggles

class ViewModel {
    
    let datasourceUrl: URL
    let mutableValueProvider: MutableValueProvider
    let remoteValueProvider: RemoteValueProvider
    let localValueProvider: ValueProvider
    let manager: ToggleManager
    
    init(datasourceUrl: URL) throws {
        self.datasourceUrl = datasourceUrl
        mutableValueProvider = UserDefaultsProvider(userDefaults: .standard)
        remoteValueProvider = try RemoteValueProvider(jsonURL: datasourceUrl)
        localValueProvider = try LocalValueProvider(jsonURL: datasourceUrl)
        manager = try ToggleManager(mutableValueProvider: mutableValueProvider,
                                    valueProviders: [remoteValueProvider, localValueProvider],
                                    datasourceUrl: datasourceUrl)
    }
}
