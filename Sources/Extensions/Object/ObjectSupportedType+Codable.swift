//  ObjectSupportedType+Codable.swift

import Foundation

extension ObjectSupportedType: Codable {
    public init(from decoder: Decoder) throws {
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
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        
        switch self {
        case .bool(let bool):
            try container.encode(bool)
        case .int(let int):
            try container.encode(int)
        case .number(let number):
            try container.encode(number)
        case .string(let string):
            try container.encode(string)
        }
    }
}
