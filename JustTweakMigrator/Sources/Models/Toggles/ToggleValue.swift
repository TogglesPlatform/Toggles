//  ToggleValue.swift

import Foundation

enum ToggleValue: Equatable, Encodable {
    case bool(Bool)
    case int(Int)
    case number(Double)
    case string(String)
    case secure(String)
}

extension ToggleValue: Comparable {
    
    static func < (lhs: ToggleValue, rhs: ToggleValue) -> Bool {
        switch (lhs, rhs) {
        case (.bool(let a), .bool(let b)):
            return a != b
        case (.int(let a), .int(let b)):
            return a < b
        case (.number(let a), .number(let b)):
            return a < b
        case (.string(let a), .string(let b)):
            return a < b
        case (.secure(let a), .secure(let b)):
            return a < b
        default:
            return false
        }
    }
}
