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
    
    /// Returns whether the given variable has an active override.
    /// - Parameter variable: The variable to check.
    /// - Returns: `true` if the variable is overridden, `false` otherwise.
    func isOverridden(_ variable: Variable) -> Bool {
        queue.sync {
            guard let mutableValueProvider = mutableValueProvider else { return false }
            return mutableValueProvider.value(for: variable) != nil
        }
    }
    
    /// Removes all overridden toggles in the mutable value provider, if one was provided during initialization.
    @discardableResult
    public func removeOverrides() -> Set<Variable> {
        queue.sync(flags: .barrier) {
            guard let mutableValueProvider = mutableValueProvider else { return  [] }
            let variables = mutableValueProvider.variables
            log("Deleting all overrides.")
            mutableValueProvider.deleteAll()
            
            // Clear cache for all variables that had overrides
            for variable in variables {
                cache[variable] = nil
            }
            
            // Send updated values to existing subjects
            for variable in variables {
                DispatchQueue.main.async {
                    if let subject = self.subjectsRefs[variable] {
                        let newValue = self.value(for: variable)
                        subject.send(newValue)
                    }
                }
            }
            
            hasOverrides = false
            return variables
        }
    }
}
