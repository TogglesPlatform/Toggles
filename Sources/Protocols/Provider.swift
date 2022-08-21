//  Provider.swift

import Foundation

public protocol ValueProvider {
    func value(for variable: Toggle.Variable) -> Toggle.Value
}

public protocol NullableValueProvider {
    func nullableValue(for variable: Toggle.Variable) -> Toggle.Value?
}

public protocol MutableValueProvider: NullableValueProvider {
    func set(_ value: Toggle.Value, for variable: Toggle.Variable)
    func delete(_ variable: Toggle.Variable)
}
