//  TogglesValidator.swift

import Foundation

final class TogglesValidator {
    
    enum LoaderError: Equatable, Error {
        case foundDuplicateVariables([ToggleVariable])
    }
    
    static func validate(_ toggles: [Toggle]) throws {
        let duplicateVariables = Dictionary(grouping: toggles, by: \.variable)
            .filter { $1.count > 1 }
            .keys
        if duplicateVariables.count > 0 {
            throw LoaderError.foundDuplicateVariables(Array(duplicateVariables))
        }
    }
}
