//  Publishing.swift

import Combine

protocol Publishing {
    func publisher(for variable: Variable) -> AnyPublisher<Value, Never>
}
