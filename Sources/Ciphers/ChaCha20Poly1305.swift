//  ChaCha20Poly1305.swift

import Foundation
import CryptoKit

struct ChaCha20Poly1305: Ciphering {
    
    enum CipherError: Error {
        case invalidKey(String)
        case invalidValue(String)
        case invalidDecryptedData(Data)
    }

    let key: String
    
    func encrypt(_ value: String) throws -> String {
        guard let dataToEncrypt = value.data(using: .utf8) else {
            throw CipherError.invalidValue(value)
        }
        let symmetricKey = try makeSymmetricKey(key: key)
        let encryptedData = try ChaChaPoly.seal(dataToEncrypt, using: symmetricKey)
        return encryptedData.combined.base64EncodedString()
    }
    
    func decrypt(_ value: String) throws -> String {
        guard let base64StringData = Data(base64Encoded: value) else {
            throw CipherError.invalidValue(value)
        }
        let symmetricKey = try makeSymmetricKey(key: key)
        let sealedBox = try ChaChaPoly.SealedBox(combined: base64StringData)
        let decryptedData = try ChaChaPoly.open(sealedBox, using: symmetricKey)
        guard let base64StringData = String(data: decryptedData, encoding: .utf8) else {
            throw CipherError.invalidDecryptedData(decryptedData)
        }
        return base64StringData
    }

    private func makeSymmetricKey(key: String) throws -> SymmetricKey {
        guard let keyData = key.data(using: .utf8) else {
            throw CipherError.invalidKey(key)
        }
        let hash = SHA256.hash(data: keyData)
        return SymmetricKey(data: hash)
    }
}
