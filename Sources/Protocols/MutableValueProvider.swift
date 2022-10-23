//  MutableValueProvider.swift

import Foundation

/// Protocol to be implemented by custom mutable value providers.
/// A MutableValueProvider is a ValueProvider that allows settings and deleting values for given variables.
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
