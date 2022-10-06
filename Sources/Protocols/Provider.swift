//  Provider.swift

import Foundation

/// Protocol to be implemented by custom value providers.
/// Value providers allows retrieving values for given variables.
public protocol ValueProvider {
    var name: String { get }
    
    /// Retrieve the value for a variable.
    ///
    /// - Parameter variable: The variable to retrieve the value for.
    /// - Returns: The value for the given variable.
    func value(for variable: Variable) -> Value?
}

/// Protocol to be implemented by custom mutable providers Value providers.
/// A mutable value provider is a value provider that allows settings and deleting values for given variables.
public protocol MutableValueProvider: ValueProvider {
    
    /// Sets the value for a variable.
    ///
    /// - Parameters:
    ///   - value: The value to set.
    ///   - variable: The variable to set the value for.
    func set(_ value: Value, for variable: Variable)
    
    /// Deletes the value for a variable.
    ///
    /// - Parameter variable: The variable to delete the value for.
    func delete(_ variable: Variable)
    
    /// Deletes all the values set on the provider.
    func deleteAll()
    
    /// Set of variables set on the provider.
    var variables: Set<Variable> { get }
}
