//  LocalValueProvider.swift

import Foundation

public class LocalValueProvider: ValueProvider {
    
    public var name: String { "Local" }
    
    private let toggles: [Variable: Value]
    
    public init(jsonURL: URL) throws {
        let content = try Data(contentsOf: jsonURL)
        let datasource = try JSONDecoder().decode(Datasource.self, from: content)
        self.toggles = Dictionary(grouping: datasource.toggles, by: \.variable)
            .mapValues { $0.first! }
            .mapValues { $0.value }
    }
    
    public func value(for variable: Variable) -> Value {
        toggles[variable] ?? .none
    }
}
