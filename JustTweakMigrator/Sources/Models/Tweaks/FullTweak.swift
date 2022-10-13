//  FullTweak.swift

import Foundation

struct FullTweak {
    let title: String
    let description: String
    let group: String
    let value: Any
    let encrypted: Bool
    let generatedPropertyName: String?
    let variable: String
    let feature: String
}

extension FullTweak: Equatable {
    
    static func == (lhs: FullTweak, rhs: FullTweak) -> Bool {
        guard lhs.title == rhs.title else { return false }
        guard lhs.description == rhs.description else { return false }
        guard lhs.group == rhs.group else { return false }
        guard lhs.encrypted == rhs.encrypted else { return false }
        guard lhs.generatedPropertyName == rhs.generatedPropertyName else { return false }
        guard lhs.variable == rhs.variable else { return false }
        guard lhs.feature == rhs.feature else { return false }
        switch (lhs.value, rhs.value) {
        case (let lhsValue as Bool, let rhsValue as Bool):
            return lhsValue == rhsValue
        case (let lhsValue as Int, let rhsValue as Int):
            return lhsValue == rhsValue
        case (let lhsValue as Double, let rhsValue as Double):
            return lhsValue == rhsValue
        case (let lhsValue as String, let rhsValue as String):
            return lhsValue == rhsValue
        default:
            return false
        }
    }
}

extension FullTweak: Comparable {
    
    static func < (lhs: FullTweak, rhs: FullTweak) -> Bool {
        lhs.variable < rhs.variable
    }
}
