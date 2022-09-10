//  Provider.swift

import Foundation

public protocol Nameable {
    var name: String { get }
}

public protocol ValueProvider: Nameable {
    func value(for variable: Variable) -> Value
}

public protocol MutableValueProvider: ValueProvider {
    func set(_ value: Value, for variable: Variable)
    func delete(_ variable: Variable)
    func deleteAll() -> Set<Variable>
    var overrides: Set<Variable> { get }
}
