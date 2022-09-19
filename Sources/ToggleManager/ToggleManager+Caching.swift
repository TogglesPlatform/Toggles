//  ToggleManager+Caching.swift

import Foundation

extension ToggleManager {
    
    public var hasOverrides: Bool {
        queue.sync {
            guard let mutableValueProvider = mutableValueProvider else { return false }
            return !mutableValueProvider.variables.isEmpty
        }
    }
    
    @discardableResult
    public func removeOverrides() -> Set<Variable> {
        queue.sync {
            defer { cache.evict() }
            guard let mutableValueProvider = mutableValueProvider else { return  [] }
            let variables = mutableValueProvider.variables
            mutableValueProvider.deleteAll()
            return variables
        }
    }
    
    func getCachedValue(for variable: Variable) -> Value? {
        queue.sync {
            cache[variable]
        }
    }
}
