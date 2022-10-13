//  Toggle.swift

import Foundation

struct Toggle {
    let variable: ToggleVariable
    let value: ToggleValue
    let metadata: ToggleMetadata
}

extension Toggle: Comparable {
    
    static func < (lhs: Toggle, rhs: Toggle) -> Bool {
        lhs.variable < rhs.variable
    }
}
