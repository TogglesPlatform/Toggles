//  ToggleManager.swift

import Combine
import Foundation

final public class ToggleManager {
    
    var mutableValueProvider: MutableValueProvider?
    var valueProviders: [ValueProvider]
    var defaultValueProvider: ValueProvider
    var cypherConfiguration: CypherConfiguration?
    
    let queue = DispatchQueue(label: "com.albertodebortoli.Toggles.ToggleManager", attributes: .concurrent)
    let cache = ValueCache<Variable, Value>()
    var subjectsRefs = [Variable: CurrentValueSubject<Value, Never>]()

    public init(mutableValueProvider: MutableValueProvider? = nil,
                valueProviders: [ValueProvider] = [],
                datasourceUrl: URL,
                cypherConfiguration: CypherConfiguration? = nil) throws {
        self.mutableValueProvider = mutableValueProvider
        self.valueProviders = valueProviders
        self.defaultValueProvider = try DefaultValueProvider(jsonURL: datasourceUrl)
        self.cypherConfiguration = cypherConfiguration
    }
}

extension ToggleManager {
    
    public func value(for variable: Variable) -> Value {
        queue.sync {
            nonSyncValue(for: variable)
        }
    }
    
    internal func nonSyncValue(for variable: Variable) -> Value {
        let value = cache[variable] ?? fetchValueFromProviders(for: variable)
        cache[variable] = value
        return try! readValue(for: value)
    }
    
    private func fetchValueFromProviders(for variable: Variable) -> Value {
        if let value = mutableValueProvider?.value(for: variable), value != .none {
            return value
        }
        for provider in valueProviders {
            let value = provider.value(for: variable)
            if value != .none {
                return value
            }
        }
        return defaultValueProvider.value(for: variable)
    }
}

extension ToggleManager {
    
    public func set(_ value: Value, for variable: Variable) {
        queue.async(flags: .barrier) {
            guard let mutableValueProvider = self.mutableValueProvider else {
//                assertionFailure("No MutableValueProvider available. Cannot call `set(_, for:)` on \(self).")
                return
            }
            guard value != .none else {
//                assertionFailure("Cannot set `.none` value.")
                return
            }
            let writeValue = try! self.writeValue(for: value)
            self.cache[variable] = writeValue
            mutableValueProvider.set(writeValue, for: variable)
            self.subjectsRefs[variable]?.send(value)
        }
    }
    
    public func delete(_ variable: Variable) {
        queue.async(flags: .barrier) {
            guard let mutableValueProvider = self.mutableValueProvider else { return }
            self.cache[variable] = nil
            mutableValueProvider.delete(variable)
            self.subjectsRefs[variable]?.send(completion: .finished)
            self.subjectsRefs[variable] = nil
        }
    }
}

extension ToggleManager {
    
    func set(_ dictionary: [Variable: Value]) {
        for (key, value) in dictionary {
            set(value, for: key)
        }
    }
}
