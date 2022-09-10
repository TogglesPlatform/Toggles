//  ViewModel.swift

import Foundation
import Combine
import Toggles

class ViewModel {
    
    let dataSourceUrl: URL
    let mutableValueProvider: MutableValueProvider
    let remoteValueProvider: RemoteValueProvider
    let localValueProvider: ValueProvider
    let manager: ToggleManager
    
    init(dataSourceUrl: URL) throws {
        self.dataSourceUrl = dataSourceUrl
        mutableValueProvider = UserDefaultsProvider(userDefaults: .standard)
        remoteValueProvider = try RemoteValueProvider(jsonURL: dataSourceUrl)
        localValueProvider = try LocalValueProvider(jsonURL: dataSourceUrl)
        manager = try ToggleManager(mutableValueProvider: mutableValueProvider,
                                    valueProviders: [remoteValueProvider, localValueProvider],
                                    dataSourceUrl: dataSourceUrl)
    }
}
