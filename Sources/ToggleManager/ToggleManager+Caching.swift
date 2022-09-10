//  ToggleManager+Caching.swift

import Foundation

extension ToggleManager {
    
    public var hasOverrides: Bool {
        guard let mutableValueProvider = mutableValueProvider else { return false }
        return !mutableValueProvider.variables.isEmpty
    }
    
    public func removeOverrides() -> Set<Variable> {
        defer { cache.evict() }
        guard let mutableValueProvider = mutableValueProvider else { return  [] }
        let variables = mutableValueProvider.variables
        mutableValueProvider.deleteAll()
        return variables
    }
}

extension ToggleManager {
    
    func set(_ dictionary: [Variable: Value]) {
        for (key, value) in dictionary {
            set(value, for: key)
        }
    }
}
