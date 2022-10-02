//  Cyphering.swift

import Foundation

protocol Cyphering {
    func encrypt(_ value: String) throws -> String
    func decrypt(_ value: String) throws -> String
}
