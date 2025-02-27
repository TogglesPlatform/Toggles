//  LocalValueProvider.swift

public import Foundation

/// Value provider with a local datasource.
final public class LocalValueProvider {
    
    public let name: String
    
    private let toggles: [Variable: Value]
    
    public var variables: [Variable] {
        toggles.map(\.key)
    }
    
    /// The default initializer.
    ///
    /// - Parameter jsonUrl: The url to the file containing the toggles.
    public init(name: String = "Local", jsonUrl: URL) throws {
        let content = try Data(contentsOf: jsonUrl)
        let datasource = try JSONDecoder().decode(Datasource.self, from: content)
        let groupedToggles = Dictionary(grouping: datasource.toggles, by: \.variable)
        try TogglesValidator.validate(groupedToggles)
        self.name = name
        self.toggles = groupedToggles
            .mapValues { $0.first! }
            .mapValues { $0.value }
    }
}

extension LocalValueProvider: ValueProvider {
    
    public func value(for variable: Variable) -> Value? {
        toggles[variable]
    }
}
