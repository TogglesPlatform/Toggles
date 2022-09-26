//  Toggle+Utilities.swift

import Foundation

extension Toggle {
    
    var accessibilityLabel: String {
        metadata.description + "has value" + value.description
    }
}
