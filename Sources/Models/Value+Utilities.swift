//  Value+Utilities.swift

import Foundation

typealias SFSymbolId = String

extension Value {
    
    var description: String {
        switch self {
        case .bool(let value):
            return String(value)
        case .int(let value):
            return String(value)
        case .number(let value):
            return String(value)
        case .string(let value):
            return value
        }
    }
    
    var typeDescription: String {
        switch self {
        case .bool:
            return "Bool"
        case .int:
            return "Int"
        case .number:
            return "Double"
        case .string:
            return "String"
        }
    }
    
    var sfSymbolId: SFSymbolId {
        switch self {
        case .bool:
            return "switch.2"
        case .int:
            return "number.square"
        case .number:
            return "number.square.fill"
        case .string:
            return "textformat"
        }
    }
}
