//  UserDefaultsProvider.swift

import Foundation

private let userDefaultsKeyPrefix = "com.toggles"

final public class UserDefaultsProvider: MutableValueProvider {
    
    public var name: String = "UserDefaults"
    
    private let userDefaults: UserDefaults
    
    public init(userDefaults: UserDefaults) {
        self.userDefaults = userDefaults
    }
    
    public func value(for variable: Variable) -> Value {
        let data = userDefaults.value(forKey: key(for: variable)) as? Data
        guard let data = data else { return .none }
        return try! PropertyListDecoder().decode(Value.self, from: data)
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

extension UserDefaultsProvider {
    
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
