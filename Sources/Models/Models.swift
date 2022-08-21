//  Models.swift

import Foundation

public struct Toggle: Equatable, Codable {

    public typealias Variable = String

    public enum Value: Equatable, Codable {
        case bool(value: Bool)
        case int(value: Int)
        case number(value: Double)
        case string(value: String)
    }
    
    public let variable: Variable
    public let value: Value
}

public struct ToggleMetadata: Equatable, Decodable {
    public let variable: Toggle.Variable
    public let description: String
    public let group: String
}

public struct DataSource: Equatable, Decodable {
    public let toggles: [Toggle]
    public let metadata: [ToggleMetadata]
}

public extension Toggle.Value {

    var boolValue: Bool? {
        guard case let .bool(v) = self else { return nil }
        return v
    }
    
    var intValue: Int? {
        guard case let .int(v) = self else { return nil }
        return v
    }
    
    var doubleValue: Double? {
        guard case let .number(v) = self else { return nil }
        return v
    }
    
    var stringValue: String? {
        guard case let .string(v) = self else { return nil }
        return v
    }
}
