//  PersistentValueProvider.swift

import Foundation

private let userDefaultsKeyPrefix = "com.toggles"

/// Mutable value provider that persists toggles in the user defaults.
/// Alterations to toggles are therefore persisted across app restarts and updates.
final public class PersistentValueProvider: @unchecked Sendable {
    
    public let name: String
    
    private let userDefaults: UserDefaults
    
    /// The default initializer.
    ///
    /// - Parameter userDefaults: The user defaults to store the toggles to.
    public init(name: String = "Persistent", userDefaults: UserDefaults) {
        self.name = name
        self.userDefaults = userDefaults
    }
}

extension PersistentValueProvider: MutableValueProvider {
    
    public func value(for variable: Variable) -> Value? {
        guard let data = userDefaults.value(forKey: key(for: variable)) as? Data else { return nil }
        return try? PropertyListDecoder().decode(Value.self, from: data)
    }
    
    public func set(_ value: Value, for variable: Variable) {
        let data = try! PropertyListEncoder().encode(value)
        userDefaults.set(data, forKey: key(for: variable))
        addSavedVariable(variable)
    }
    
    public func delete(_ variable: Variable) {
        userDefaults.removeObject(forKey: key(for: variable))
        removeSavedVariable(variable)
    }
    
    public func deleteAll() {
        savedVariables.forEach {
            userDefaults.removeObject(forKey: key(for: $0))
        }
        wipeSavedVariables()
    }
    
    public var variables: Set<Variable> {
        savedVariables
    }
    
    // MARK: - Private
    
    private func key(for identifier: String) -> String {
        [userDefaultsKeyPrefix, identifier].joined(separator: ".")
    }
}

extension PersistentValueProvider {
    
    enum Constants: String {
        case savedVariables
    }
    
    private var savedVariables: Set<Variable> {
        guard let variables = userDefaults.value(forKey: Constants.savedVariables.rawValue) as? String else { return [] }
        return Set(variables
            .split(separator: ",")
            .map { String($0).trimmingCharacters(in: .whitespacesAndNewlines) })
    }
    
    private func wipeSavedVariables() {
        userDefaults.removeObject(forKey: Constants.savedVariables.rawValue)
    }
    
    private func addSavedVariable(_ variable: Variable) {
        var variables = savedVariables
        variables.insert(variable)
        userDefaults.set(variables.joined(separator: ","), forKey: Constants.savedVariables.rawValue)
    }
    
    private func removeSavedVariable(_ variable: Variable) {
        var variables = savedVariables
        variables.remove(variable)
        userDefaults.set(variables.joined(separator: ","), forKey: Constants.savedVariables.rawValue)
    }
}
