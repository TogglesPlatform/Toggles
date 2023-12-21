//  ToggleManager.swift

import Combine
import Foundation

/// Thread-safe facade to interface with toggles.
final public class ToggleManager: ObservableObject {
    
    public struct ToggleManagerOptions: OptionSet {
        public var rawValue: UInt
        
        public init(rawValue: UInt) {
            self.rawValue = rawValue
        }
        
        static let skipInvalidValueTypes = ToggleManagerOptions(rawValue: 1 << 0)
        static let skipInvalidSecureValues = ToggleManagerOptions(rawValue: 1 << 1)
        static let noCaching = ToggleManagerOptions(rawValue: 1 << 2)
    }
    
    var mutableValueProvider: MutableValueProvider?
    var valueProviders: [ValueProvider]
    var defaultValueProvider: DefaultValueProvider
    var cipherConfiguration: CipherConfiguration?
    
    let queue = DispatchQueue(label: "com.albertodebortoli.Toggles.ToggleManager", attributes: .concurrent)
    let cache = ValueCache<Variable, Value>()
    var subjectsRefs = [Variable: CurrentValueSubject<Value, Never>]()
    let options: [ToggleManagerOptions]
    
    @Published var hasOverrides: Bool = false
    
    /// Set to `true` to enable console logging on CRUD operations.
    public var verbose: Bool = false
    
    /// The default initializer.
    ///
    /// - Parameters:
    ///   - mutableValueProvider: An optional mutable provider used for setting and deleting toggle values. If provided, this provider is the one with highest priority when searching for a toggle. If not provided, the ToggleManager has a read-only setup.
    ///   - valueProviders: An array or providers that can retrieve toggle values. The providers must be listed in order of priority.
    ///   - datasourceUrl: The url to a file containing the datasource used the base. If no mutableValueProvider and no valueProviders are provided, the manager will always return the values from the datasource.
    ///   - cipherConfiguration: An optional configuration that needs to be provided in the case any toggle is secure (meaning it needs encryption and decryption).
    public init(mutableValueProvider: MutableValueProvider? = nil,
                valueProviders: [ValueProvider] = [],
                datasourceUrl: URL,
                cipherConfiguration: CipherConfiguration? = nil,
                options: [ToggleManagerOptions] = []) throws {
        self.mutableValueProvider = mutableValueProvider
        self.valueProviders = valueProviders
        self.defaultValueProvider = try DefaultValueProvider(jsonURL: datasourceUrl)
        self.cipherConfiguration = cipherConfiguration
        if let mutableValueProvider = self.mutableValueProvider {
            self.hasOverrides = !mutableValueProvider.variables.isEmpty
        }
        self.options = options
    }
}

extension ToggleManager {
    
    /// Retrieves the value for a toggle and caches it for subsequents retrievals.
    ///
    /// - Parameter variable: The variable of the toggle to retrieve the value for.
    /// - Returns: The value of the toggle.
    public func value(for variable: Variable) -> Value {
        queue.sync {
            let value = nonSyncValue(for: variable)
            log("Getting value \(value) for variable \(variable).")
            return value
        }
    }
    
    private func nonSyncValue(for variable: Variable) -> Value {
        let value = cache[variable] ?? fetchValueFromProviders(for: variable)
        cache[variable] = shouldCache ? value : nil
        return try! readValue(for: value)
    }
    
    private func fetchValueFromProviders(for variable: Variable) -> Value {
        let defaultValue: Value? = defaultValueProvider.optionalValue(for: variable)
        
        if let value = mutableValueProvider?.value(for: variable), isValueValid(value: value, defaultValue: defaultValue) {
            return value
        }
        for provider in valueProviders {
            if let value = provider.value(for: variable), isValueValid(value: value, defaultValue: defaultValue) {
                return value
            }
        }
        return defaultValue!
    }
    
    private var shouldCheckInvalidSecureValues: Bool {
        return options.contains(.skipInvalidSecureValues)
    }

    private var shouldCheckInvalidValueTypes: Bool {
        return options.contains(.skipInvalidValueTypes)
    }
    
    private var shouldCache: Bool {
        return !options.contains(.noCaching)
    }
    
    private func isValueValid(value: Value, defaultValue: Value?) -> Bool {
        if shouldCheckInvalidValueTypes, let defaultValue, !(value ~= defaultValue) {
            return false
        }
        
        if shouldCheckInvalidSecureValues, ((try? readValue(for: value)) == nil) {
            return false
        }
        
        return true
    }
}

extension ToggleManager {
    
    /// Sets the value for a toggle and caches it for subsequents retrievals.
    ///
    /// - Parameters:
    ///   - value: The value to set for the toggle.
    ///   - variable: The variable of the toggle to set the value to.
    public func set(_ value: Value, for variable: Variable) {
        log("Setting value (\(value) for variable \(variable).")
        queue.async(flags: .barrier) {
            guard let mutableValueProvider = self.mutableValueProvider else {
                assertionFailure("No MutableValueProvider available: unallowed call `set(_, for:)` on \(self).")
                return
            }
            let writeValue = try! self.writeValue(for: value)
            self.cache[variable] = self.shouldCache ? writeValue : nil
            mutableValueProvider.set(writeValue, for: variable)
            DispatchQueue.main.async {
                self.subjectsRefs[variable]?.send(value)
                self.hasOverrides = true
            }
        }
    }
    
    /// Deletes a toggle and removes it from the cache.
    ///
    /// - Parameter variable: The variable of the toggle to delete.
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
