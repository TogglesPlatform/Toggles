//  ToggleManager.swift

import Foundation

final public class ToggleManager {
    
    var mutableValueProvider: MutableValueProvider?
    var optionalValueProviders: [OptionalValueProvider]
    var valueProvider: ValueProvider
    
    let queue = DispatchQueue(label: "com.albertodebortoli.Toggles.ToggleManager", attributes: .concurrent)
    private let cache = Cache<Variable, Value>()
    
    public init(mutableValueProvider: MutableValueProvider? = nil,
                optionalValueProviders: [OptionalValueProvider] = [],
                dataSourceUrl: URL) throws {
        self.mutableValueProvider = mutableValueProvider
        self.optionalValueProviders = optionalValueProviders
        self.valueProvider = try LocalValueProvider(jsonURL: dataSourceUrl)
    }
}

extension ToggleManager {
    
    public func value(for variable: Variable) -> Value {
        if let cached = cache[variable] { return cached }
        let value = fetchValue(for: variable)
        cache[variable] = value
        return value
    }
    
    private func fetchValue(for variable: Variable) -> Value {
        queue.sync {
            if let value = mutableValueProvider?.optionalValue(for: variable) { return value }
            for provider in optionalValueProviders {
                if let value = provider.optionalValue(for: variable) {
                    return value
                }
            }
            return valueProvider.value(for: variable)
        }
    }
}

extension ToggleManager {
    
    public func optionalValue(for variable: Variable) -> Value? {
        value(for: variable)
    }
    
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

extension ToggleManager {
    public func removeOverrides() {
        mutableValueProvider?.deleteAll()
        cache.evict()
    }
}

extension ToggleManager {
    func set(_ dictionary: [Variable: Value]) {
        for (key, value) in dictionary {
            set(value, for: key)
        }
    }
}
