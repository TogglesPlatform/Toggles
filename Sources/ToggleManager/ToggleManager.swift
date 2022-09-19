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
    
    enum FetchError: Error {
        case missingCypherConfiguration
    }
    
    public func value(for variable: Variable) -> Value {
        queue.sync {
            if let cachedValue = cache[variable] {
                return decryptedValue(for: cachedValue)
            }

            if let value = mutableValueProvider?.value(for: variable), value != .none {
                cache[variable] = value
                return decryptedValue(for: value)
            }
            for provider in valueProviders {
                let value = provider.value(for: variable)
                if value != .none {
                    cache[variable] = value
                    return decryptedValue(for: value)
                }
            }
            let value = defaultValueProvider.value(for: variable)
            cache[variable] = value
            return decryptedValue(for: value)
        }
    }
}

extension ToggleManager {
    
    public func set(_ value: Value, for variable: Variable) {
        queue.async(flags: .barrier) {
            guard let mutableValueProvider = self.mutableValueProvider else { return }
            let value = self.encryptedValue(for: value)
            self.cache[variable] = value
            mutableValueProvider.set(value, for: variable)
        }
    }
    
    public func delete(_ variable: Variable) {
        queue.async(flags: .barrier) {
            guard let mutableValueProvider = self.mutableValueProvider else { return }
            self.cache[variable] = nil
            mutableValueProvider.delete(variable)
        }
    }
}
