//  ObjectSupportedType+Equatable.swift

import Foundation

extension ObjectSupportedType: Equatable {
    public static func == (lhs: ObjectSupportedType, rhs: ObjectSupportedType) -> Bool {
        switch (lhs, rhs) {
        case (.int(let lhsInt), .int(let rhsInt)):
            return lhsInt == rhsInt
        case (.bool(let lhsBool), .bool(let rhsBool)):
            return lhsBool == rhsBool
        case (.string(let lhsString), .string(let rhsString)):
            return lhsString == rhsString
        case (.number(let lhsNumber), .number(let rhsNumber)):
            return lhsNumber == rhsNumber
        default: return false
        }
    }
}
