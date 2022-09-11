//  ChaCha20Poly1305Encryptor.swift

import Foundation
import CryptoKit

final public class ChaCha20Poly1305Encryptor {
    
    enum EncryptionError: Error {
        case invalidKey(String)
        case invalidValue(String)
    }

    private let key: String
    
    public init(key: String) {
        self.key = key
    }
    
    public func encrypt(_ value: String) throws -> String {
        guard let dataToEncrypt = value.data(using: .utf8) else {
            throw EncryptionError.invalidValue(value)
        }
        let symmetricKey = try makeSymmetricKey(key: key)
        let encryptedData = try ChaChaPoly.seal(dataToEncrypt, using: symmetricKey)
        return encryptedData.combined.base64EncodedString()
    }
    
    public func decrypt(_ value: String) throws -> String {
        guard let base64StringData = Data(base64Encoded: value) else {
            throw EncryptionError.invalidValue(value)
        }
        let symmetricKey = try makeSymmetricKey(key: key)
        let sealedBox = try ChaChaPoly.SealedBox(combined: base64StringData)
        let decryptedData = try ChaChaPoly.open(sealedBox, using: symmetricKey)
        return String(data: decryptedData, encoding: .utf8) ?? ""
    }

    private func makeSymmetricKey(key: String) throws -> SymmetricKey {
        guard let keyData = key.data(using: .utf8) else {
            throw EncryptionError.invalidKey(key)
        }
        let hash = SHA256.hash(data: keyData)
        return SymmetricKey(data: hash)
    }
}
