//  NullableLocalValueProvider.swift

import Foundation

class NullableLocalValueProvider: NullableValueProvider {
    
    private let toggles: [Toggle.Variable: Toggle.Value]
    
    init(jsonURL: URL) throws {
        let content = try Data(contentsOf: jsonURL)
        let dataSource = try JSONDecoder().decode(DataSource.self, from: content)
        self.toggles = Dictionary(grouping: dataSource.toggles, by: \.variable)
            .mapValues { $0.first! }
            .mapValues { $0.value }
    }
    
    func nullableValue(for variable: Toggle.Variable) -> Toggle.Value? {
        toggles[variable]
    }
}
