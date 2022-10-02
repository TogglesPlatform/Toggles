//  ToggleManager+Cyphering.swift

extension ToggleManager {
    
    enum FetchError: Error {
        case missingCypherConfiguration
    }
    
    func writeValue(for value: Value) throws -> Value {
        switch value {
        case .secure(let plaintextValue):
            let encryptedValue: String = try encrypt(plaintextValue)
            return .secure(encryptedValue)
        default:
            return value
        }
    }
    
    private func encrypt(_ value: String) throws -> String {
        guard let cypherConfiguration = cypherConfiguration else {
            throw FetchError.missingCypherConfiguration
        }
        let cypher: Cypher
        switch cypherConfiguration.algorithm {
        case Algorithm.chaCha20Poly1305:
            cypher = ChaCha20Poly1305(key: cypherConfiguration.key)
        }
        return try cypher.encrypt(value)
    }
    
    func readValue(for value: Value) throws -> Value {
        switch value {
        case .secure(let encryptedValue):
            let decryptedValue: String = try decrypt(encryptedValue)
            return .secure(decryptedValue)
        default:
            return value
        }
    }
    
    private func decrypt(_ value: String) throws -> String {
        guard let cypherConfiguration = cypherConfiguration else {
            throw FetchError.missingCypherConfiguration
        }
        let cypher: Cypher
        switch cypherConfiguration.algorithm {
        case Algorithm.chaCha20Poly1305:
            cypher = ChaCha20Poly1305(key: cypherConfiguration.key)
        }
        return try cypher.decrypt(value)
    }
}

