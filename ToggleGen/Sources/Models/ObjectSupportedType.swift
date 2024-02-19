//  ObjectSupportedType.swift

import Foundation

enum ObjectSupportedType: Equatable, Decodable {
    case bool(Bool)
    case int(Int)
    case number(Double)
    case string(String)
    
    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let bool = try? container.decode(Bool.self) {
            self = .bool(bool)
        } else if let int = try? container.decode(Int.self) {
            self = .int(int)
        } else if let number = try? container.decode(Double.self) {
            self = .number(number)
        } else if let string = try? container.decode(String.self) {
            self = .string(string)
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "ObjectSupportedType tried to decode unsupported type, could not decode")
        }
    }
}

