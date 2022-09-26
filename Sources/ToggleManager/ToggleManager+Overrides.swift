//  ToggleManager+Overrides.swift

import Foundation

extension ToggleManager {
    
    public var overriddedVariables: [Variable] {
        queue.sync {
            guard let mutableValueProvider = mutableValueProvider else { return [] }
            return Array(mutableValueProvider.variables)
        }
    }
    
    @discardableResult
    public func removeOverrides() -> Set<Variable> {
        queue.sync {
            defer { cache.evict() }
            guard let mutableValueProvider = mutableValueProvider else { return  [] }
            let variables = mutableValueProvider.variables
            for variable in variables {
                DispatchQueue.main.async {
                    self.subjectsRefs[variable]?.send(completion: .finished)
                    self.subjectsRefs[variable] = nil
                }
            }
            mutableValueProvider.deleteAll()
            hasOverrides = false
            return variables
        }
    }
}
