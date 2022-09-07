//  ToggleManager+Publishing.swift

import Combine
import Foundation

extension ToggleManager: Publishing {
    
    public func publisher(for variable: Variable) -> AnyPublisher<Value, Never> {
        if let cachedSubject = subjectsRefs[variable] {
            return cachedSubject
                .eraseToAnyPublisher()
        }
        let subject = CurrentValueSubject<Value, Never>(value(for: variable))
        subjectsRefs[variable] = subject
        return subject
            .eraseToAnyPublisher()
    }
}
