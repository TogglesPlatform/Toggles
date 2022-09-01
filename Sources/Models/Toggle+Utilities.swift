//  Toggle+Utilities.swift

import Foundation

extension Toggle {
    var accessibilityLabel: String {
        metadata.description + "has value" + value.description
    }
}

extension Toggle {
    func byUpdatingValue(_ value2: Value) -> Toggle {
        Toggle(variable: variable, value: value2, metadata: metadata)
    }
}
