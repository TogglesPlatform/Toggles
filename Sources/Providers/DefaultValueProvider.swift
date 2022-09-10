//  DefaultValueProvider.swift

import Foundation

class DefaultValueProvider: ValueProvider {
    
    public var name: String { "Default" }
    
    private let toggles: [Variable: Value]
    
    init(jsonURL: URL) throws {
        let content = try Data(contentsOf: jsonURL)
        let dataSource = try JSONDecoder().decode(DataSource.self, from: content)
        self.toggles = Dictionary(grouping: dataSource.toggles, by: \.variable)
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
