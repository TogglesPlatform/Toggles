//  ToggleManager+Caching.swift

import Foundation

extension ToggleManager {
    public func removeOverrides() {
        mutableValueProvider?.deleteAll()
        cache.evict()
    }
}

extension ToggleManager {
    func set(_ dictionary: [Variable: Value]) {
        for (key, value) in dictionary {
            set(value, for: key)
        }
    }
}
