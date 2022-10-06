//  CipherConfiguration.swift

import Foundation

public enum Algorithm: String {
    case chaCha20Poly1305
}

public typealias CipherKey = String

public struct CipherConfiguration {
    let algorithm: Algorithm
    let key: CipherKey
    
    public init(algorithm: Algorithm, key: CipherKey) {
        self.algorithm = algorithm
        self.key = key
    }
}
