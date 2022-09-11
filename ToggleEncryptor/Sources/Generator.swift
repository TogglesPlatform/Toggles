//  Generator.swift

import ArgumentParser
import Foundation

@main
struct Generator: ParsableCommand {
    
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
            let encryptor = ChaCha20Poly1305Encryptor(key: key)
            let encryptedValue = try encryptor.encrypt(value)
            print("Plaintext value: \"\(value)\"")
            print("Encrypted value: \"\(encryptedValue)\"")
        }
    }
}
