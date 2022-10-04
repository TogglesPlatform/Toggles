//  ToggleManager+Overrides.swift

import Foundation

extension ToggleManager {
    
    public var overriddedVariables: Set<Variable> {
        queue.sync {
            guard let mutableValueProvider = mutableValueProvider else { return [] }
            return mutableValueProvider.variables
        }
    }
    
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
