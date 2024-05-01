//  ObjectSupportedType.swift

import Foundation

/// Supported types for `Object`
public enum ObjectSupportedType: Sendable {
    case bool(Bool)
    case int(Int)
    case number(Double)
    case string(String)
}
