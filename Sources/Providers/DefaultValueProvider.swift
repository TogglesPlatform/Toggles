//  DefaultValueProvider.swift

import Foundation

final class DefaultValueProvider {
    
    let name: String
    
    let toggles: [Variable: Value]
    
    init(name: String = "Default", jsonURL: URL) throws {
        let content = try Data(contentsOf: jsonURL)
        let datasource = try JSONDecoder().decode(Datasource.self, from: content)
        let groupedToggles = Dictionary(grouping: datasource.toggles, by: \.variable)
        try TogglesValidator.validate(groupedToggles)
        self.name = name
        self.toggles = groupedToggles
            .mapValues { $0.first! }
            .mapValues { $0.value }
    }
    
    func value(for variable: Variable) -> Value {
        guard let value = toggles[variable] else {
            assertionFailure("Not found value for variable \(variable) in \(name) provider.")
            return .bool(false)
        }
        return value
    }
    
    func optionalValue(for variable: Variable) -> Value? {
        guard let value = toggles[variable] else {
            return nil
        }
        return value
    }
}
