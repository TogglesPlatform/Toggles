//  ChaCha20Poly1305Decryptor.swift

import Foundation
import CryptoKit

final public class ChaCha20Poly1305Decryptor {
    
    enum DecryptionError: Error {
        case invalidKey(String)
        case invalidValue(String)
        case invalidDecryptedData(Data)
    }

    private let key: String
    
    public init(key: String) {
        self.key = key
    }
    
    public func decrypt(_ value: String) throws -> String {
        guard let base64StringData = Data(base64Encoded: value) else {
            throw DecryptionError.invalidValue(value)
        }
        let symmetricKey = try makeSymmetricKey(key: key)
        let sealedBox = try ChaChaPoly.SealedBox(combined: base64StringData)
        let decryptedData = try ChaChaPoly.open(sealedBox, using: symmetricKey)
        guard let base64StringData = String(data: decryptedData, encoding: .utf8) else {
            throw DecryptionError.invalidDecryptedData(decryptedData)
        }
        return base64StringData
    }

    private func makeSymmetricKey(key: String) throws -> SymmetricKey {
        guard let keyData = key.data(using: .utf8) else {
            throw DecryptionError.invalidKey(key)
        }
        let hash = SHA256.hash(data: keyData)
        return SymmetricKey(data: hash)
    }
}
