//  Dictionary+Toggles.swift

import Foundation

extension Dictionary where Key == String, Value == Any {
    internal enum ToggleConversionError: Error, Equatable {
        case unsupportedValueType(String)
        
        public static func ==(lhs: Dictionary.ToggleConversionError, rhs: Dictionary.ToggleConversionError) -> Bool {
            switch (lhs, rhs) {
            case (.unsupportedValueType(let leftValue), .unsupportedValueType(let rightValue)):
                return leftValue == rightValue
            }
        }
    }
    
    public func convertToTogglesDataSource() throws -> [Variable: Toggles.Value] {
        
        var resultDictionary: [Variable: Toggles.Value] = [:]
        
        try resultDictionary = self.mapValues { value in
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
        
        return resultDictionary
    }
}
