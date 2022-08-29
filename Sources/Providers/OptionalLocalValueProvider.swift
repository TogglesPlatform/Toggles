//  OptionalLocalValueProvider.swift

import Foundation

public class OptionalLocalValueProvider: OptionalValueProvider {
    
    public var name: String { "Optional Local" }
    
    private let toggles: [Variable: Value]
    
    public init(jsonURL: URL) throws {
        let content = try Data(contentsOf: jsonURL)
        let dataSource = try JSONDecoder().decode(DataSource.self, from: content)
        self.toggles = Dictionary(grouping: dataSource.toggles, by: \.variable)
            .mapValues { $0.first! }
            .mapValues { $0.value }
    }
    
    public func optionalValue(for variable: Variable) -> Value? {
        toggles[variable]
    }
}
