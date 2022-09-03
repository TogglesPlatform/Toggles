//  ToggleManager+Subjects.swift

import Combine
import Foundation

extension ToggleManager {
    
    func subject(for variable: Variable) -> ToggleValueSubject {
        if let cachedSubject = subjectsRefs[variable] { return cachedSubject }
        let subject = ToggleValueSubject(value(for: variable))
        subjectsRefs[variable] = subject
        return subject
    }
    
    func applyConfigurationChanges() {
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
