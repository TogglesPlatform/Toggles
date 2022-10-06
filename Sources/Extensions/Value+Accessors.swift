//  Value+Accessors.swift

import Foundation

public extension Value {

    /// The raw value of the toggle if it's of boolean type, nil otherwise.
    var boolValue: Bool? {
        guard case let .bool(v) = self else { return nil }
        return v
    }

    /// The raw value of the toggle if it's of integer type, nil otherwise.
    var intValue: Int? {
        guard case let .int(v) = self else { return nil }
        return v
    }

    /// The raw value of the toggle if it's of number type, nil otherwise.
    var numberValue: Double? {
        guard case let .number(v) = self else { return nil }
        return v
    }
    
    /// The raw value of the toggle if it's of string type, nil otherwise.
    var stringValue: String? {
        guard case let .string(v) = self else { return nil }
        return v
    }
    
    /// The raw value of the toggle if it's of secure type, nil otherwise.
    var secureValue: String? {
        guard case let .secure(v) = self else { return nil }
        return v
    }
}
