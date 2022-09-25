//  ToggleManager+Caching.swift

import Foundation

extension ToggleManager {
    
    @discardableResult
    public func removeOverrides() -> Set<Variable> {
        queue.sync {
            defer { cache.evict() }
            guard let mutableValueProvider = mutableValueProvider else { return  [] }
            let variables = mutableValueProvider.variables
            mutableValueProvider.deleteAll()
            hasOverrides = false
            return variables
        }
    }
    
    func getCachedValue(for variable: Variable) -> Value? {
        queue.sync {
            cache[variable]
        }
    }
}
