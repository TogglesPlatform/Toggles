//  DecryptionConfiguration.swift

import Foundation

public enum Algorithm: String {
    case chaCha20Poly1305
}

public typealias Key = String

public struct CypherConfiguration {
    let algorithm: Algorithm
    let key: Key
    
    public init(algorithm: Algorithm, key: Key) {
        self.algorithm = algorithm
        self.key = key
    }
}
