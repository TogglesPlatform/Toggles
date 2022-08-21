//  LocalValueProvider.swift

import Foundation

class LocalValueProvider: ValueProvider {
    
    private let toggles: [Toggle.Variable: Toggle.Value]
    
    init(jsonURL: URL) throws {
        let content = try Data(contentsOf: jsonURL)
        let dataSource = try JSONDecoder().decode(DataSource.self, from: content)
        self.toggles = Dictionary(grouping: dataSource.toggles, by: \.variable)
            .mapValues { $0.first! }
            .mapValues { $0.value }
    }
    
    func value(for variable: Toggle.Variable) -> Toggle.Value {
        toggles[variable]!
    }
}
