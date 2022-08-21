//  ToggleManager.swift

import Foundation

final public class ToggleManager {
    
    private var mutableValueProvider: MutableValueProvider?
    private var nullableValueProviders: [NullableValueProvider]
    private var valueProvider: ValueProvider
    
    private let queue = DispatchQueue(label: "com.albertodebortoli.toggles", attributes: .concurrent)
    private let cache = Cache<Toggle.Variable, Toggle.Value>()
    
    public init(mutableValueProvider: MutableValueProvider? = nil,
                nullableValueProviders: [NullableValueProvider] = [],
                valueProvider: ValueProvider) {
        self.mutableValueProvider = mutableValueProvider
        self.nullableValueProviders = nullableValueProviders
        self.valueProvider = valueProvider
    }
}

extension ToggleManager: ValueProvider {
    public func value(for variable: Toggle.Variable) -> Toggle.Value {
        if let cached = cache[variable] { return cached }
        let value = fetchValue(for: variable)
        cache[variable] = value
        return value
    }
    
    private func fetchValue(for variable: Toggle.Variable) -> Toggle.Value {
        queue.sync {
            if let value = mutableValueProvider?.nullableValue(for: variable) { return value }
            for provider in nullableValueProviders {
                if let value = provider.nullableValue(for: variable) {
                    return value
                }
            }
            return valueProvider.value(for: variable)
        }
    }
}

extension ToggleManager: MutableValueProvider {
    
    public func nullableValue(for variable: Toggle.Variable) -> Toggle.Value? {
        value(for: variable)
    }
    
    public func set(_ value: Toggle.Value, for variable: Toggle.Variable) {
        cache[variable] = value
        queue.async(flags: .barrier) {
            self.mutableValueProvider?.set(value, for: variable)
        }
    }
    
    public func delete(_ variable: Toggle.Variable) {
        cache[variable] = nil
        queue.async(flags: .barrier) {
            self.mutableValueProvider?.delete(variable)
        }
    }
}

extension ToggleManager {
    public func evictCache() {
        cache.evict()
    }
}

extension ToggleManager {
    func set(_ dictionary: [Toggle.Variable: Toggle.Value]) {
        for (key, value) in dictionary {
            set(value, for: key)
        }
    }
}
