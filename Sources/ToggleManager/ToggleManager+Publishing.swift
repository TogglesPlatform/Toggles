//  ToggleManager+Publishing.swift

import Combine
import Foundation

extension ToggleManager: Publishing {
    
    /// Generates a publisher that publishes value updates for a specified toggle.
    /// Publishers are cached for reuse.
    ///
    /// - Parameter variable: The variable for the toggle to get a publisher for.
    /// - returns: A type-erased `CurrentValueSubject` publishing new values for a toggle.
    public func publisher(for variable: Variable) -> AnyPublisher<Value, Never> {
        if let cachedSubject = subjectsRefs[variable] {
            log("Returning existing subject for variable \(variable).")
            return cachedSubject
                .eraseToAnyPublisher()
        }
        let subject = CurrentValueSubject<Value, Never>(value(for: variable))
        subjectsRefs[variable] = subject
        log("Creating new subject for variable \(variable).")
        return subject
            .eraseToAnyPublisher()
    }
}
