//  ToggleMetadata.swift

import Foundation

struct ToggleMetadata: Encodable {
    let description: String
    let group: String
    let propertyName: String?
}

extension ToggleMetadata: Comparable {
    
    static func < (lhs: ToggleMetadata, rhs: ToggleMetadata) -> Bool {
        lhs.description < rhs.description
    }
}
