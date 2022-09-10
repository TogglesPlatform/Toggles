//  ViewModel.swift

import Foundation
import Combine
import Toggles

class ViewModel {
    
    let dataSourceUrl: URL
    let mutableValueProvider: MutableValueProvider
    let remoteValueProvider: RemoteValueProvider
    let localNullableValueProvider: ValueProvider
    let manager: ToggleManager
    
    init(dataSourceUrl: URL) throws {
        self.dataSourceUrl = dataSourceUrl
        mutableValueProvider = UserDefaultsProvider(userDefaults: .standard)
        remoteValueProvider = try RemoteValueProvider(jsonURL: dataSourceUrl)
        localNullableValueProvider = try LocalNullableValueProvider(jsonURL: dataSourceUrl)
        manager = try ToggleManager(mutableValueProvider: mutableValueProvider,
                                    valueProviders: [remoteValueProvider, localNullableValueProvider],
                                    dataSourceUrl: dataSourceUrl)
    }
}
