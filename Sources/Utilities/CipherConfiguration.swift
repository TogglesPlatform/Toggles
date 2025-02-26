//  CipherConfiguration.swift

import Foundation

/// Enumeration of supported cipher algorithms used to encrypt and decrypt secure toggles.
public enum Algorithm: String, Sendable {
    /// The [ChaChaPoly cipher](https://developer.apple.com/documentation/cryptokit/chachapoly) from Apple's CryptoKit.
    /// See [Wikipedia reference](https://en.wikipedia.org/wiki/ChaCha20-Poly1305) for more details.
    case chaCha20Poly1305
}

/// Alias to better refer to a cipher key.
public typealias CipherKey = String

/// Configuration describing what cipher algorigthm use for encrypting and decrypting secure toggles.
public struct CipherConfiguration: Sendable {
    let algorithm: Algorithm
    let key: CipherKey
    let ignoreEmptyStrings: Bool
    
    public init(algorithm: Algorithm, key: CipherKey, ignoreEmptyStrings: Bool = false) {
        self.algorithm = algorithm
        self.key = key
        self.ignoreEmptyStrings = ignoreEmptyStrings
    }
}
