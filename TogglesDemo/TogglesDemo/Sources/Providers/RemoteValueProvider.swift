//  RemoteValueProvider.swift

import Foundation
import Toggles

public class RemoteValueProvider: OptionalValueProvider {
    
    public var name: String = "Remote (demo)"
    
    private var toggles: [Variable: Value]
    
    public init(jsonURL: URL) throws {
        let content = try Data(contentsOf: jsonURL)
        let datasource = try JSONDecoder().decode(Datasource.self, from: content)
        self.toggles = Dictionary(grouping: datasource.toggles, by: \.variable)
            .mapValues { $0.first! }
            .mapValues { $0.value }
    }
    
    public func value(for variable: Variable) -> Value? {
        toggles[variable]
    }
    
    public func fakeLoadLatestConfiguration(_ completion: () -> Void) {
        self.toggles = toggles.mapValues { value in
            switch value {
            case .bool:
                return .bool(Int(arc4random()) % 2 == 0 ? false : true)
            case .int:
                return .int(Int(arc4random()) % 100)
            case .number:
                return .number(Double(Int(arc4random()) % 100) + Double((Int(arc4random()) % 100)) / 100)
            case .string:
                return .string(Int(arc4random()) % 2 == 0 ? "Hello World" : "Ciao mondo")
            case .secure:
                return .secure(Int(arc4random()) % 2  == 0 ?
                               "YXe+Ev76FbdwCeDCVpZNZ1RItWZwKTLXF3/Yi+x62n3JWbvPo6YK" :
                                "xvuqELiuOMgSB6TvnU9V350uXV81GSd/SXvp8oFP42xyHswSww==")
            }
        }
        completion()
    }
}
