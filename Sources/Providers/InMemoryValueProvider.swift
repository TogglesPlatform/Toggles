//  InMemoryValueProvider.swift

import Foundation

final public class InMemoryValueProvider {
    
    public var name: String = "InMemory"
    
    private var storage: [Variable: Value]
    
    public init(datasource: [Variable: Value] = [Variable: Value]()) {
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
