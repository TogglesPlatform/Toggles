//  ToggleManager+Reacting.swift

import Combine
import Foundation

extension ToggleManager {
    
    public func reactToConfigurationChanges() {
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
