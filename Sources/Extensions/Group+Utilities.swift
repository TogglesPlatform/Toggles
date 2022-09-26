//  Group.swift

import Foundation

extension Group {
    
    var accessibilityLabel: String {
        switch toggles.count {
        case 0:
            return "Group " + title + " has no toggles"
        case 1:
            return "Group " + title + " has 1 toggle"
        default:
            return "Group " + title + " has \(toggles.count) toggles"
        }
    }
}
