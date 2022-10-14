//  Toggle.swift

import Foundation

struct Toggle {
    let variable: ToggleVariable
    let value: ToggleValue
    let metadata: ToggleMetadata
}

extension Toggle: Comparable {
    
    static func < (lhs: Toggle, rhs: Toggle) -> Bool {
        if lhs.variable != rhs.variable {
            return lhs.variable < rhs.variable
        }
        if lhs.value != rhs.value {
            return lhs.value < rhs.value
        }
        return lhs.metadata < rhs.metadata
    }
}
