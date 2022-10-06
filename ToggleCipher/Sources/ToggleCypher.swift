//  Generator.swift

import ArgumentParser
import Foundation

@main
struct Generator: AsyncParsableCommand {
    
    static let configuration = CommandConfiguration(
        abstract: "",
        subcommands: [
            Encrypt.self,
            Decrypt.self
        ]
    )
}
