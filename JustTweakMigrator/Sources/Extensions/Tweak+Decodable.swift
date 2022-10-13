//  Tweak+Codable.swift

import Foundation

extension Tweak: Decodable {
    
    enum CodingError: Error {
        case invalidValue
    }
    
    enum CodingKeys: String, CodingKey {
        case title = "Title"
        case description = "Description"
        case group = "Group"
        case value = "Value"
        case encrypted = "Encrypted"
        case generatedPropertyName = "GeneratedPropertyName"
    }
    
    init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try values.decode(String.self, forKey: .title)
        self.description = try values.decode(String.self, forKey: .description)
        self.group = try values.decode(String.self, forKey: .group)
        self.encrypted = (try? values.decodeIfPresent(Bool.self, forKey: .encrypted)) ?? false
        self.generatedPropertyName = try? values.decodeIfPresent(String.self, forKey: .generatedPropertyName)

        if let boolValue = try? values.decode(Bool.self, forKey: .value) {
            self.value = boolValue
        }
        else if let intValue = try? values.decode(Int.self, forKey: .value) {
            self.value = intValue
        }
        else if let doubleValue = try? values.decode(Double.self, forKey: .value) {
            self.value = doubleValue
        }
        else if let stringValue = try? values.decode(String.self, forKey: .value) {
            self.value = stringValue
        }
        else {
            throw CodingError.invalidValue
        }
    }
}
