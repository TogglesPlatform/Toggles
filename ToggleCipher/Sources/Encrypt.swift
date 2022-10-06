//  Encrypt.swift

import ArgumentParser
import Foundation

struct Encrypt: ParsableCommand {
    
    @Option(name: .long, help: "The algorithm to use.")
    var algorithm: Algorithm
    
    @Option(name: .long, help: "The key to use for the algorithm.")
    var key: String
    
    @Option(name: .long, help: "The value to encrypt.")
    var value: String
    
    enum Algorithm: String, ExpressibleByArgument {
        case chaCha20Poly1305 = "chaChaPoly"
    }
    
    mutating func run() throws {
        switch algorithm {
        case .chaCha20Poly1305:
            let cypher = ChaCha20Poly1305(key: key)
            let encryptedValue = try cypher.encrypt(value)
            print("Plaintext value: \"\(value)\"")
            print("Encrypted value: \"\(encryptedValue)\"")
        }
    }
}
