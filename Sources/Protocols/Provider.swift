//  Provider.swift

import Foundation

public protocol ValueProvider {
    var name: String { get }
    func value(for variable: Variable) -> Value?
}

public protocol MutableValueProvider: ValueProvider {
    func set(_ value: Value, for variable: Variable)
    func delete(_ variable: Variable)
    func deleteAll()
    var variables: Set<Variable> { get }
}
