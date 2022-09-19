//  TogglesValidator.swift

import Foundation

final class TogglesValidator {
    
    enum LoaderError: Equatable, Error {
        case foundDuplicateVariables([Variable])
    }
    
    static func validate(_ groupedToggles: [Variable: [Toggle]]) throws {
        let duplicateVariables = groupedToggles
            .filter { $1.count > 1 }
            .compactMap { String($0.0) }
            .map { String($0) }
            .sorted()
        if duplicateVariables.count > 0 {
            throw LoaderError.foundDuplicateVariables(duplicateVariables)
        }
    }
}
