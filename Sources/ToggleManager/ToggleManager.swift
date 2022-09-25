//  ToggleManager.swift

import Combine
import Foundation

final public class ToggleManager {
    
    var mutableValueProvider: MutableValueProvider?
    var valueProviders: [OptionalValueProvider]
    var defaultValueProvider: ValueProvider
    var cypherConfiguration: CypherConfiguration?
    
    let queue = DispatchQueue(label: "com.albertodebortoli.Toggles.ToggleManager", attributes: .concurrent)
    let cache = ValueCache<Variable, Value>()
    var subjectsRefs = [Variable: CurrentValueSubject<Value, Never>]()

    public init(mutableValueProvider: MutableValueProvider? = nil,
                valueProviders: [OptionalValueProvider] = [],
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
        if let value = mutableValueProvider?.value(for: variable) {
            return value
        }
        for provider in valueProviders {
            if let value = provider.value(for: variable) {
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
                assertionFailure("No MutableValueProvider available: unallowed call `set(_, for:)` on \(self).")
                return
            }
            let writeValue = try! self.writeValue(for: value)
            self.cache[variable] = writeValue
            mutableValueProvider.set(writeValue, for: variable)
            DispatchQueue.main.async {
                self.subjectsRefs[variable]?.send(value)
            }
        }
    }
    
    public func delete(_ variable: Variable) {
        queue.async(flags: .barrier) {
            guard let mutableValueProvider = self.mutableValueProvider else {
                assertionFailure("No MutableValueProvider available: unallowed call `delete(_)` on \(self).")
                return
            }
            self.cache[variable] = nil
            mutableValueProvider.delete(variable)
            DispatchQueue.main.async {
                self.subjectsRefs[variable]?.send(completion: .finished)
                self.subjectsRefs[variable] = nil
            }
        }
    }
}
