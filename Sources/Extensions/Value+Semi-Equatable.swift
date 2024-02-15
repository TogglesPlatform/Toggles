//  Value+Semi-Equatable.swift

import Foundation

extension Value {
    static func ~=(lhs: Value, rhs: Value) -> Bool {
        switch lhs {
        case .bool:
            if case .bool = rhs { return true }
        case .int:
            if case .int = rhs { return true }
        case .number:
            if case .number = rhs { return true }
        case .string:
            if case .string = rhs { return true }
        case .secure:
            if case .secure = rhs { return true }
        case .object:
            if case .object = rhs { return true }
        }
        return false
    }
}
