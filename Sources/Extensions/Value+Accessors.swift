//  Value+Accessors.swift

import Foundation

public extension Value {

    var boolValue: Bool? {
        guard case let .bool(v) = self else { return nil }
        return v
    }

    var intValue: Int? {
        guard case let .int(v) = self else { return nil }
        return v
    }

    var numberValue: Double? {
        guard case let .number(v) = self else { return nil }
        return v
    }
    
    var stringValue: String? {
        guard case let .string(v) = self else { return nil }
        return v
    }
    
    var secureValue: String? {
        guard case let .secure(v) = self else { return nil }
        return v
    }
}
