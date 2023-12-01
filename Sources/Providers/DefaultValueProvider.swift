//  DefaultValueProvider.swift

import Foundation

final class DefaultValueProvider {
    
    var name: String = "Default"
    
    private let toggles: [Variable: Value]
    
    init(jsonURL: URL) throws {
        let content = try Data(contentsOf: jsonURL)
        let datasource = try JSONDecoder().decode(Datasource.self, from: content)
        let groupedToggles = Dictionary(grouping: datasource.toggles, by: \.variable)
        try TogglesValidator.validate(groupedToggles)
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
    func getAllValues() -> [Variable: Value] {
        toggles
    }
}
