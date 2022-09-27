//  LocalValueProvider.swift

import Foundation

final public class LocalValueProvider {
    
    public var name: String = "Local"
    
    private let toggles: [Variable: Value]
    
    public init(jsonURL: URL) throws {
        let content = try Data(contentsOf: jsonURL)
        let datasource = try JSONDecoder().decode(Datasource.self, from: content)
        let groupedToggles = Dictionary(grouping: datasource.toggles, by: \.variable)
        try TogglesValidator.validate(groupedToggles)
        self.toggles = groupedToggles
            .mapValues { $0.first! }
            .mapValues { $0.value }
    }
}

extension LocalValueProvider: OptionalValueProvider {
    
    public func value(for variable: Variable) -> Value? {
        toggles[variable]
    }
}
