//  Converter.swift

import Foundation

final class Converter {
    
    enum ConverterError: Error {
        case invalidValue
    }
    
    static func convert(tweaksDatasource: TweaksDatasource) throws -> TogglesDatasource {
        let toggles = try tweaksDatasource.fullTweaks.map {
            let toggleValue: ToggleValue
            switch $0.value {
            case is Bool:
                toggleValue = .bool($0.value as! Bool)
            case is Int:
                toggleValue = .int($0.value as! Int)
            case is Double:
                toggleValue = .number($0.value as! Double)
            case is String where $0.encrypted:
                toggleValue = .secure($0.value as! String)
            case is String:
                toggleValue = .string($0.value as! String)
            default:
                throw ConverterError.invalidValue
            }
            
            let toggleMetadata = ToggleMetadata(description: $0.title,
                                                group: $0.group,
                                                propertyName: $0.generatedPropertyName)
            
            return Toggle(variable: $0.variable, value: toggleValue, metadata: toggleMetadata)
        }
        try TogglesValidator.validate(toggles)
        return TogglesDatasource(toggles: toggles.sorted())
    }
}
