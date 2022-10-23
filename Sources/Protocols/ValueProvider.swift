//  ValueProvider.swift

import Foundation

/// Protocol to be implemented by custom value providers.
/// A ValueProvider allows retrieving values for given variables.
public protocol ValueProvider {
    var name: String { get }
    
    /// Retrieve the value for a variable.
    ///
    /// - Parameter variable: The variable to retrieve the value for.
    /// - Returns: The value for the given variable.
    func value(for variable: Variable) -> Value?
}
