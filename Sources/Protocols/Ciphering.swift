//  Ciphering.swift

import Foundation

protocol Ciphering {
    func encrypt(_ value: String) throws -> String
    func decrypt(_ value: String) throws -> String
}
