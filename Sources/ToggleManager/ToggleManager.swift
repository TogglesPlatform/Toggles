//  ToggleManager.swift

import Combine
import Foundation

final public class ToggleManager: ObservableObject {
    
    var mutableValueProvider: MutableValueProvider?
    var valueProviders: [OptionalValueProvider]
    var defaultValueProvider: DefaultValueProvider
    var cipherConfiguration: CipherConfiguration?
    
    let queue = DispatchQueue(label: "com.albertodebortoli.Toggles.ToggleManager", attributes: .concurrent)
    let cache = ValueCache<Variable, Value>()
    var subjectsRefs = [Variable: CurrentValueSubject<Value, Never>]()
    
    @Published var hasOverrides: Bool = false
    public var verbose: Bool = false
    
    public init(mutableValueProvider: MutableValueProvider? = nil,
                valueProviders: [OptionalValueProvider] = [],
                datasourceUrl: URL,
                cipherConfiguration: CipherConfiguration? = nil) throws {
        self.mutableValueProvider = mutableValueProvider
        self.valueProviders = valueProviders
        self.defaultValueProvider = try DefaultValueProvider(jsonURL: datasourceUrl)
        self.cipherConfiguration = cipherConfiguration
        if let mutableValueProvider = self.mutableValueProvider {
            self.hasOverrides = !mutableValueProvider.variables.isEmpty
        }
    }
}

extension ToggleManager {
    
    public func value(for variable: Variable) -> Value {
        queue.sync {
            let value = nonSyncValue(for: variable)
            log("Getting value \(value) for variable \(variable).")
            return value
        }
    }
    
    private func nonSyncValue(for variable: Variable) -> Value {
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
        log("Setting value (\(value) for variable \(variable).")
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
                self.hasOverrides = true
            }
        }
    }
    
    public func delete(_ variable: Variable) {
        log("Deleting variable \(variable).")
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
                self.hasOverrides = !mutableValueProvider.variables.isEmpty
            }
        }
    }
}
