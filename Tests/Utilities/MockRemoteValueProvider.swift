//  MockRemoteValueProvider.swift

import Foundation
@testable import Toggles

final class MockRemoteValueProvider: OptionalValueProvider {
    
    var name: String = "Remote (mock)"
    
    private var toggles: [Variable: Value]
    
    init(jsonURL: URL) throws {
        let content = try Data(contentsOf: jsonURL)
        let datasource = try JSONDecoder().decode(Datasource.self, from: content)
        self.toggles = Dictionary(grouping: datasource.toggles, by: \.variable)
            .mapValues { $0.first! }
            .mapValues { $0.value }
    }
    
    func value(for variable: Variable) -> Value? {
        toggles[variable]
    }
    
    func fakeLoadLatestConfiguration(_ completion: () -> Void) {
        self.toggles = toggles.mapValues { value in
            switch value {
            case .bool(let v):
                return .bool(!v)
            case .int(let v):
                return .int(v + 1)
            case .number(let v):
                return .number(v + 1.0)
            case .string(let v):
                return .string(v + "!")
            case .secure(let v):
                let cipher = ChaCha20Poly1305(key: CipherConfiguration.chaChaPoly.key)
                let decryptedValue = try! cipher.decrypt(v)
                let updatedValue = decryptedValue + "!"
                return .secure(try! cipher.encrypt(updatedValue))
            }
        }
        completion()
    }
}
