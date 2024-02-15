//  ObjectSupportedType+Utilities.swift

import Foundation

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

extension Dictionary where Value == ObjectSupportedType {
    var anyValue: [Key: Any] {
        reduce(into: [:], { result, next in
            result[next.key] = next.value.anyValue
        })
    }
}

