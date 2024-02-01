//  ObjectSupportedType.swift

import Foundation

/// Supported types for `Object`
public enum ObjectSupportedType: Codable {
    case bool(Bool)
    case int(Int)
    case number(Double)
    case string(String)

    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        if let bool = try? container.decode(Bool.self) {
            self = .bool(bool)
        } else if let int = try? container.decode(Int.self) {
            self = .int(int)
        } else if let number = try? container.decode(Double.self) {
            self = .number(number)
        } else if let string = try? container.decode(String.self) {
            self = .string(string)
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "ObjectSupportedType tried to decode unsupported type, could not decode")
        }
    }
}

public extension ObjectSupportedType {
    /// The raw value of the `Object`'s property, if it's of boolean type, nil otherwise.
    var boolValue: Bool? {
        guard case let .bool(v) = self else { return nil }
        return v
    }

    /// The raw value of the `Object`'s property, if it's of integer type, nil otherwise.
    var intValue: Int? {
        guard case let .int(v) = self else { return nil }
        return v
    }

    /// The raw value of the `Object`'s property, if it's of number type, nil otherwise.
    var numberValue: Double? {
        guard case let .number(v) = self else { return nil }
        return v
    }
    
    /// The raw value of the `Object`'s property, if it's of string type, nil otherwise.
    var stringValue: String? {
        guard case let .string(v) = self else { return nil }
        return v
    }
}

extension ObjectSupportedType {
    var anyValue: Any {
        switch self {
        case .bool(let bool): return bool
        case .int(let int): return int
        case .string(let string): return string
        case .number(let number): return number
        }
    }
}
