//  Toggle+Codable.swift

import Foundation

extension Toggle: Encodable {
    
    enum CodingError: Error {
        case missingValue
    }
    
    enum CodingKeys: String, CodingKey {
        case variable
        case bool
        case int
        case number
        case string
        case secure
        case metadata
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(variable, forKey: .variable)
        
        switch value {
        case .bool(let value):
            try container.encode(value, forKey: .bool)
        case .int(let value):
            try container.encode(value, forKey: .int)
        case .number(let value):
            try container.encode(value, forKey: .number)
        case .string(let value):
            try container.encode(value, forKey: .string)
        case .secure(let value):
            try container.encode(value, forKey: .secure)
        }
        try container.encode(metadata, forKey: .metadata)
    }
}
