//  UserDefaultsProvider.swift

import Foundation

private let userDefaultsKeyPrefix = "com.toggles"

public class UserDefaultsProvider: MutableValueProvider {
    
    private let userDefaults: UserDefaults
    
    public init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
    
    public func nullableValue(for variable: Toggle.Variable) -> Toggle.Value? {
        userDefaults.value(forKey: key(for: variable)) as? Toggle.Value
    }
    
    public func set(_ value: Toggle.Value, for variable: Toggle.Variable) {
        userDefaults.set(value, forKey: key(for: variable))
    }
    
    public func delete(_ variable: Toggle.Variable) {
        userDefaults.set(nil, forKey: key(for: variable))
    }
    
    // MARK: - Private
    
    private func key(for identifier: String) -> String {
        [userDefaultsKeyPrefix, identifier].joined(separator: ".")
    }
}
