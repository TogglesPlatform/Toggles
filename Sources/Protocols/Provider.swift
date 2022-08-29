//  Provider.swift

import Foundation

public protocol Nameable {
    var name: String { get }
}

protocol ValueProvider: Nameable {
    func value(for variable: Variable) -> Value
}

public protocol OptionalValueProvider: Nameable {
    func optionalValue(for variable: Variable) -> Value?
}

public protocol MutableValueProvider: OptionalValueProvider {
    func set(_ value: Value, for variable: Variable)
    func delete(_ variable: Variable)
}
