//  Value.swift

import Foundation

public enum Value: Equatable, Codable {
    case bool(Bool)
    case int(Int)
    case number(Double)
    case string(String)
    case encrypted(String)
}
