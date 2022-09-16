//  DefaultValueProvider.swift

import Foundation

class DefaultValueProvider: ValueProvider {
    
    private enum LoaderError: Error {
        case foundDuplicateVariables([Variable])
    }
    
    public var name: String { "Default" }
    
    private let toggles: [Variable: Value]
    
    init(jsonURL: URL) throws {
        let content = try Data(contentsOf: jsonURL)
        let datasource = try JSONDecoder().decode(Datasource.self, from: content)
        let groupedToggles = Dictionary(grouping: datasource.toggles, by: \.variable)
        try Self.validate(groupedToggles)
        self.toggles = groupedToggles
            .mapValues { $0.first! }
            .mapValues { $0.value }
    }
    
    func value(for variable: Variable) -> Value {
        let value = toggles[variable]!
        if case .none = value {
            assertionFailure("Found .none value for variable \(variable) in \(name) provider.")
        }
        return value
    }
}

extension DefaultValueProvider {
    
    private static func validate(_ groupedToggles: [Variable: [Toggle]]) throws {
        let duplicateVariables = groupedToggles
            .filter { $1.count > 1 }
            .compactMap { String($0.0) }
            .map { String($0) }
        if duplicateVariables.count > 0 {
            throw LoaderError.foundDuplicateVariables(duplicateVariables)
        }
    }
}
