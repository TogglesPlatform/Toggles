//  InMemoryValueProvider.swift

import Foundation

/// Mutable value provider that stores toggles in memory.
/// Alterations to toggles are not persisted.
final public class InMemoryValueProvider: @unchecked Sendable {
    
    public let name: String
    
    private var storage: [Variable: Value]
    
    /// The default initializer.
    ///
    /// - Parameter datasource: The toggles datasource in the form of dictionary of `Variable`s and `Value`s.
    public init(name: String = "InMemory", datasource: [Variable: Value] = [Variable: Value]()) {
        self.name = name
        self.storage = datasource
    }
}

extension InMemoryValueProvider: MutableValueProvider {
    
    public func value(for variable: Variable) -> Value? {
        storage[variable]
    }
    
    public func set(_ value: Value, for variable: Variable) {
        storage[variable] = value
    }
    
    public func delete(_ variable: Variable) {
        storage.removeValue(forKey: variable)
    }
    
    public func deleteAll() {
        storage.removeAll()
    }
    
    public var variables: Set<Variable> {
        Set(storage.keys)
    }
}
