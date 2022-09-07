//  ToggleManager+Caching.swift

import Foundation

extension ToggleManager {
    
    public var hasOverrides: Bool {
        guard let mutableValueProvider = mutableValueProvider else { return false }
        return !mutableValueProvider.overrides.isEmpty
    }
    
    public func removeOverrides() -> [Variable] {
        cache.evict()
        return mutableValueProvider?.deleteAll() ?? []
    }
}

extension ToggleManager {
    
    func set(_ dictionary: [Variable: Value]) {
        for (key, value) in dictionary {
            set(value, for: key)
        }
    }
}
