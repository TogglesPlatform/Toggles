//  Decrypt.swift

import ArgumentParser
import Foundation

struct Decrypt: ParsableCommand {
    
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
            let cipher = ChaCha20Poly1305(key: key)
            let decryptedValue = try cipher.decrypt(value)
            print("Encrypted value: \"\(value)\"")
            print("Decrypted value: \"\(decryptedValue)\"")
        }
    }
}
