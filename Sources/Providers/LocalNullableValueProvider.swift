//  LocalNullableValueProvider.swift

import Foundation

public class LocalNullableValueProvider: ValueProvider {
    
    public var name: String { "Local Nullable" }
    
    private let toggles: [Variable: Value]
    
    public init(jsonURL: URL) throws {
        let content = try Data(contentsOf: jsonURL)
        let dataSource = try JSONDecoder().decode(DataSource.self, from: content)
        self.toggles = Dictionary(grouping: dataSource.toggles, by: \.variable)
            .mapValues { $0.first! }
            .mapValues { $0.value }
    }
    
    public func value(for variable: Variable) -> Value {
        toggles[variable] ?? .none
    }
}
