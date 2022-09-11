//  ToggleManager+Cyphering.swift

extension ToggleManager {
    
    func encryptedValue(for value: Value) -> Value {
        switch value {
        case .secure(let plaintextValue):
            let encryptedValue: String = (try? encrypt(plaintextValue)) ?? "<corrupted value>"
            return .secure(encryptedValue)
        default:
            return value
        }
    }
    
    private func encrypt(_ value: String) throws -> String {
        guard let cypherConfiguration = cypherConfiguration else {
            throw FetchError.missingCypherConfiguration
        }
        switch cypherConfiguration.algorithm {
        case Algorithm.chaCha20Poly1305:
            let cypher = ChaCha20Poly1305(key: cypherConfiguration.key)
            return try cypher.encrypt(value)
        }
    }
    
    func decryptedValue(for value: Value) -> Value {
        switch value {
        case .secure(let encryptedValue):
            let decryptedValue: String = (try? decrypt(encryptedValue)) ?? "<corrupted value>"
            return .secure(decryptedValue)
        default:
            return value
        }
    }
    
    private func decrypt(_ value: String) throws -> String {
        guard let cypherConfiguration = cypherConfiguration else {
            throw FetchError.missingCypherConfiguration
        }
        switch cypherConfiguration.algorithm {
        case Algorithm.chaCha20Poly1305:
            let cypher = ChaCha20Poly1305(key: cypherConfiguration.key)
            return try cypher.decrypt(value)
        }
    }
}

