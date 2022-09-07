//  Publishing.swift

import Combine
import Foundation

public protocol Publishing {
    func publisher(for variable: Variable) -> AnyPublisher<Value, Never>
}
