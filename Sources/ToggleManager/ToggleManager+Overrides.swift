//  ToggleManager+Overrides.swift

import Foundation

extension ToggleManager {
    
    /// Set of variables of overridden toggles if a mutable value provider was provided during initialization, empty set otherwise.
    public var overrides: Set<Variable> {
        queue.sync {
            guard let mutableValueProvider = mutableValueProvider else { return [] }
            return mutableValueProvider.variables
        }
    }
    
    /// Removes all overridden toggles in the mutable value provider, if one was provided during initialization.
    /// This method also clears the cache.
    @discardableResult
    public func removeOverrides() -> Set<Variable> {
        queue.sync(flags: .barrier) {
            defer { cache.evict() }
            guard let mutableValueProvider = mutableValueProvider else { return  [] }
            let variables = mutableValueProvider.variables
            for variable in variables {
                DispatchQueue.main.async {
                    self.subjectsRefs[variable]?.send(completion: .finished)
                    self.subjectsRefs[variable] = nil
                }
            }
            log("Deleting all overrides.")
            mutableValueProvider.deleteAll()
            hasOverrides = false
            return variables
        }
    }
}
