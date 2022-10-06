//  ToggleManager+Reacting.swift

import Combine
import Foundation

extension ToggleManager {
    
    /// Clears the cache and publishes new values to all cached publishers.
    /// Call this method whenever any provider received a new toggle configuration.
    public func reactToConfigurationChanges() {
        log("Reacting to configuration changes.")
        cache.evict()
        for (variable, subjectRef) in subjectsRefs {
            let previousValue = subjectRef.value
            let currentValue = value(for: variable)
            if currentValue != previousValue {
                subjectRef.send(currentValue)
            }
        }
    }
}
