//  Value.swift

import Foundation

/// Value associated with a toggle.
public enum Value: Equatable, Codable, Sendable {
    case bool(Bool)
    case int(Int)
    case number(Double)
    case string(String)
    case secure(String)
    case object(Object)
}
