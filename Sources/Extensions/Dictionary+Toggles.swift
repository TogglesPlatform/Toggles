//  Dictionary+Toggles.swift

import Foundation

extension Dictionary where Key == String, Value == Any {
    internal enum ToggleConversionError: Error, Equatable {
        case unsupportedValueType(String)
    }
    
    public func convertToTogglesDataSource() throws -> [Variable: Toggles.Value] {
        return try mapValues { value in
            switch value {
            case let stringValue as String:
                return Toggles.Value.string(stringValue)
            case let boolValue as Bool:
                return Toggles.Value.bool(boolValue)
            case let intValue as Int:
                return Toggles.Value.int(intValue)
            case let numberValue as Double:
                return Toggles.Value.number(numberValue)
            default:
                let valueType = String(describing: type(of: value))
                throw ToggleConversionError.unsupportedValueType(valueType)
            }
        }
    }
}
