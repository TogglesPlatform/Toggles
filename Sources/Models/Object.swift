//  Object.swift

import Foundation

/// Model representing object value for a Toggle.
/// It container to access a object as a dictionary or a concrete type `T`
public class Object: Codable {
    public let map: [Variable: ObjectSupportedType]
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        
        if let dictionary = try? container.decode([Variable: ObjectSupportedType].self) {
            var map = [Variable: ObjectSupportedType]()
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
    
    /// Generic function to decode Object into type `T` which must conform ``Decodable``.
    /// - Returns: Returns object T. If value can not be decoded into object T it throws Decoding exception.
    public func asType<T: Decodable>() throws -> T {
        let data = try JSONSerialization.data(withJSONObject: map.anyValue, options: [])
        return try JSONDecoder().decode(T.self, from: data)
    }
}

extension Dictionary where Value == ObjectSupportedType {
    var anyValue: [Key: Any] {
        reduce(into: [:], { result, next in
            result[next.key] = next.value.anyValue
        })
    }
}
