//  Object.swift

import Foundation

/// Model representing object value for a Toggle.
/// It container to access a object as a dictionary or a concrete type `T`
public struct Object {
    public let map: [Variable: ObjectSupportedType]
    
    /// Generic function to decode Object into type `T` which must conform ``Decodable``.
    /// - Returns: Returns object T. If value can not be decoded into object T it throws Decoding exception.
    public func asType<T: Decodable>() throws -> T {
        let data = try JSONSerialization.data(withJSONObject: map.anyValue, options: [])
        return try JSONDecoder().decode(T.self, from: data)
    }
}
