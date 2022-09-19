//  DataSourceLoader.swift

import Foundation
import Stencil

struct Constant {
    let name: String
    let value: String
}

struct AccessorInfo {
    var variable: Toggle.Variable
    var type: String
    var propertyName: String
    var constant: Constant
    var toggleType: String
}

class DataSourceLoader {
    
    private enum LoaderError: Error {
        case foundDuplicateVariables([Toggle.Variable])
        case foundDuplicatePropertyNames([String])
    }
    
    private let datasource: Datasource
    
    init(jsonURL: URL) throws {
        let content = try Data(contentsOf: jsonURL)
        datasource = try JSONDecoder().decode(Datasource.self, from: content)
        try validate()
    }
    
    private func validate() throws {
        let duplicateVariables = Dictionary(grouping: datasource.toggles, by: \.variable)
            .filter { $1.count > 1 }
            .compactMap { String($0.0) }
            .map { String($0) }
        if duplicateVariables.count > 0 {
            throw LoaderError.foundDuplicateVariables(duplicateVariables)
        }
        
        let duplicatePropertyNames = Dictionary(grouping: datasource.toggles, by: \.metadata.propertyName)
            .filter { $1.count > 1 }
            .compactMap { $0.0 }
        if duplicatePropertyNames.count > 0 {
            throw LoaderError.foundDuplicatePropertyNames(duplicatePropertyNames)
        }
    }
    
    func loadConstants() throws -> [Constant] {
        datasource.toggles.map {
            Constant(name: $0.variable.codeConstantValue,
                     value: $0.variable)
        }
    }
    
    func loadAccessorInfos() -> [AccessorInfo] {
        datasource.toggles.map { toggle in
            let constant = Constant(name: toggle.variable.codeConstantValue,
                                    value: toggle.variable)
            return AccessorInfo(variable: toggle.variable,
                                type: toggle.type,
                                propertyName: toggle.computedPropertyName,
                                constant: constant,
                                toggleType: toggle.toggleType)
        }
    }
}

extension Toggle.Variable {
    var codeConstantValue: String {
        camelCased()
    }
}

extension Toggle {
    var computedPropertyName: String {
        metadata.propertyName ?? variable.codeConstantValue
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
