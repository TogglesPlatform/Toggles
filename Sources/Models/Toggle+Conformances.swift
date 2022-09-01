//  Toggle+Conformances.swift

import Foundation

extension Toggle: Comparable {
    public static func < (lhs: Toggle, rhs: Toggle) -> Bool {
        lhs.variable < rhs.variable
    }
}

extension Toggle: Identifiable {
    public var id: String { variable }
}
