//  ToggleManager+Ciphering.swift

import CryptoKit

extension ToggleManager {
    
    enum FetchError: Error {
        case missingCipherConfiguration
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
        guard let cipherConfiguration = cipherConfiguration else {
            throw FetchError.missingCipherConfiguration
        }
        let cipher: any Ciphering
        switch cipherConfiguration.algorithm {
        case Algorithm.chaCha20Poly1305:
            cipher = ChaCha20Poly1305(key: cipherConfiguration.key)
        }
        return try cipher.encrypt(value)
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
        guard let cipherConfiguration = cipherConfiguration else {
            throw FetchError.missingCipherConfiguration
        }
        
        if value.isEmpty && cipherConfiguration.ignoreEmptyStrings {
            return ""
        }
        
        let cipher: any Ciphering
        switch cipherConfiguration.algorithm {
        case Algorithm.chaCha20Poly1305:
            cipher = ChaCha20Poly1305(key: cipherConfiguration.key)
        }
        return try cipher.decrypt(value)
    }
}

