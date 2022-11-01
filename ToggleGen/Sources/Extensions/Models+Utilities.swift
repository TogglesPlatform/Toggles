//  Models+Utilities.swift

import Foundation

extension Toggle.Variable {
    var codeVariableValue: String {
        camelCased()
    }
}

extension Toggle {
    var computedPropertyName: String {
        if let propertyName = metadata?.propertyName {
            return propertyName
        }
        return variable.codeVariableValue
    }
}

extension Toggle {
    var type: String {
        switch value {
        case .bool:
            return "Bool"
        case .int:
            return "Int"
        case .number:
            return "Double"
        case .string:
            return "String"
        case .secure:
            return "String"
        }
    }
    
    var toggleType: String {
        switch value {
        case .bool:
            return "bool"
        case .int:
            return "int"
        case .number:
            return "number"
        case .string:
            return "string"
        case .secure:
            return "secure"
        }
    }
}
