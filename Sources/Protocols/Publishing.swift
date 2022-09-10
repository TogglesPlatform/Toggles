//  Publishing.swift

import Combine

public protocol Publishing {
    func publisher(for variable: Variable) -> AnyPublisher<Value, Never>
}
