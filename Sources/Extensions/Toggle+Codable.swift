//  Toggle+Codable.swift

import Foundation

extension Toggle: Codable {
    
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
        case object
    }
    
    public init(from decoder: any Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        variable = try values.decode(Variable.self, forKey: .variable)
        if let boolValue = try? values.decode(Bool.self, forKey: .bool) {
            self.value = .bool(boolValue)
        }
        else if let intValue = try? values.decode(Int.self, forKey: .int) {
            self.value = .int(intValue)
        }
        else if let numberValue = try? values.decode(Double.self, forKey: .number) {
            self.value = .number(numberValue)
        }
        else if let stringValue = try? values.decode(String.self, forKey: .string) {
            self.value = .string(stringValue)
        }
        else if let secureValue = try? values.decode(String.self, forKey: .secure) {
            self.value = .secure(secureValue)
        }
        else if let objectValue = try? values.decode(Object.self, forKey: .object) {
            self.value = .object(objectValue)
        }
        else {
            throw CodingError.missingValue
        }
        metadata = (try? values.decode(Metadata.self, forKey: .metadata)) ?? Metadata(description: "", group: "")
    }
    
    public func encode(to encoder: any Encoder) throws {
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
        case .object(let value):
            try container.encode(value, forKey: .object)
        }
        try container.encode(metadata, forKey: .metadata)
    }
}
