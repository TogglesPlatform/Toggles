//  TogglesDatasource.swift

import Foundation

struct TogglesDatasource: Encodable {
    let toggles: [Toggle]
}

// move to extension
extension TogglesDatasource: Comparable {
    
    static func < (lhs: TogglesDatasource, rhs: TogglesDatasource) -> Bool {
        lhs.toggles.count < rhs.toggles.count
    }
}
