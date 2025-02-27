//  Object.swift

import Foundation

struct Object: Equatable, Decodable {
    let map: [String: ObjectSupportedType]
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let dictionary = try? container.decode([String: ObjectSupportedType].self) {
            var map = [String: ObjectSupportedType]()
            for (key, item) in dictionary {
                guard !key.isEmpty else {
                    throw DecodingError.dataCorruptedError(in: container, debugDescription: "JSON contained empty key. Invalid data.")
                }
                map[key] = item
            }
            if map.isEmpty {
                throw DecodingError.dataCorruptedError(in: container, debugDescription: "Empty object. Invalid data.")
            }
            
            self.map = map
        } else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Unsupported type. Invalid data.")
        }
    }
}
