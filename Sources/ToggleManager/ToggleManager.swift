//  ToggleManager.swift

import Combine
import Foundation

final public class ToggleManager {
    
    var mutableValueProvider: MutableValueProvider?
    var valueProviders: [ValueProvider]
    var defaultValueProvider: ValueProvider
    
    let queue = DispatchQueue(label: "com.albertodebortoli.Toggles.ToggleManager", attributes: .concurrent)
    let cache = Cache<Variable, Value>()
    var subjectsRefs = [Variable: CurrentValueSubject<Value, Never>]()

    public init(mutableValueProvider: MutableValueProvider? = nil,
                valueProviders: [ValueProvider] = [],
                dataSourceUrl: URL) throws {
        self.mutableValueProvider = mutableValueProvider
        self.valueProviders = valueProviders
        self.defaultValueProvider = try LocalValueProvider(jsonURL: dataSourceUrl)
    }
}

extension ToggleManager {
    
    public func value(for variable: Variable) -> Value {
        if let cachedValue = cache[variable] { return cachedValue }
        let value = fetchValue(for: variable)
        cache[variable] = value
        return value
    }
    
    private func fetchValue(for variable: Variable) -> Value {
        queue.sync {
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
}

extension ToggleManager {
    
    public func set(_ value: Value, for variable: Variable) {
        cache[variable] = value
        queue.async(flags: .barrier) {
            self.mutableValueProvider?.set(value, for: variable)
        }
    }
    
    public func delete(_ variable: Variable) {
        cache[variable] = nil
        queue.async(flags: .barrier) {
            self.mutableValueProvider?.delete(variable)
        }
    }
}
