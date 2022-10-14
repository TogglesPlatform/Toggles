//  ToggleMetadata.swift

import Foundation

struct ToggleMetadata: Codable {
    let description: String
    let group: String
    let propertyName: String?
}

extension ToggleMetadata: Comparable {
    
    static func < (lhs: ToggleMetadata, rhs: ToggleMetadata) -> Bool {
        if lhs.description != rhs.description {
            return lhs.description < rhs.description
        }
        if lhs.group != rhs.group {
            return lhs.group < rhs.group
        }
        switch (lhs.propertyName, rhs.propertyName) {
        case (.some(let lhsPropertyName), .some(let rhsPropertyName)):
            return lhsPropertyName < rhsPropertyName
        case (.some, .none):
            return false
        case (.none, .some):
            return true
        case (.none, .none):
            return false
        }
    }
}
