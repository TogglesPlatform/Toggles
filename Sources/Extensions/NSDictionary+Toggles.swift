//  NSDictionary+Toggles.swift

import Foundation

extension NSDictionary {
    public enum ToggleConversionError: Error {
        case nsDictionaryInvalidFormat
        case nsDictionaryEmpty
    }
    
    public func convertToToggleDataSource() throws -> [Variable: Toggles.Value] {
        guard let swiftDictionary = self as? [String: Any], !swiftDictionary.isEmpty else {
            throw ToggleConversionError.nsDictionaryEmpty
        }
        
        var resultDictionary: [Variable: Toggles.Value] = [:]
        
        for (key, value) in self {
            guard let keyString = key as? String else {
                throw ToggleConversionError.nsDictionaryInvalidFormat
            }
            
            switch value {
            case let stringValue as String:
                resultDictionary[keyString] = Toggles.Value.string(stringValue)
            case let boolValue as Bool:
                resultDictionary[keyString] = Toggles.Value.bool(boolValue)
            case let intValue as Int:
                resultDictionary[keyString] = Toggles.Value.int(intValue)
            case let numberValue as Double:
                resultDictionary[keyString] = Toggles.Value.number(numberValue)
            default:
                throw ToggleConversionError.nsDictionaryInvalidFormat
            }
        }
        
        return resultDictionary
    }
}
