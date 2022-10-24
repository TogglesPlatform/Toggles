//  Models+Codable.swift

import Foundation

extension Toggle: Decodable {
    
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
        case propertyName
    }
    
    public init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        variable = try values.decode(Variable.self, forKey: .variable)
        if let boolValue = try? values.decode(Bool.self, forKey: .bool) {
            self.value = .bool(boolValue)
        }
        else if let intValue = try? values.decode(Int.self, forKey: .int) {
            self.value = .int(intValue)
        }
        else if let doubleValue = try? values.decode(Double.self, forKey: .number) {
            self.value = .number(doubleValue)
        }
        else if let stringValue = try? values.decode(String.self, forKey: .string) {
            self.value = .string(stringValue)
        }
        else if let secureValue = try? values.decode(String.self, forKey: .secure) {
            self.value = .secure(secureValue)
        }
        else {
            throw CodingError.missingValue
        }
        propertyName = try values.decodeIfPresent(String.self, forKey: .propertyName)
    }
}
