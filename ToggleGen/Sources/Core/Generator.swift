//  Generator.swift

import Foundation
import Toggles

enum AccessControl: String {
    case `open`
    case `public`
    case `internal`
}

struct Constant {
    let name: String
    let value: String
}

struct AccessorInfo {
    var variable: Variable
    var type: String
    var propertyName: String
    var constant: Constant
    var toggleType: String
}

class Generator {
    
    private enum Constants: String {
        case className
        case enumName
        case accessorInfos
        case variables
        case accessControl
    }
    
    enum LoaderError: Error, Equatable {
        case foundDuplicateVariables([Variable])
        case foundDuplicatePropertyNames([String])
    }
    
    private let datasource: Datasource
    
    init(datasourceUrl: URL) throws {
        let content = try Data(contentsOf: datasourceUrl)
        datasource = try JSONDecoder().decode(Datasource.self, from: content)
        try validate()
    }
    
    func generateVariables(variablesTemplatePath: String,
                           variablesEnumName: String,
                           accessControl: AccessControl) throws -> String {
        let templater = Templater()
        let variablesTemplateUrl = URL(fileURLWithPath: variablesTemplatePath)
        let variablesContext: [String: Any] = [
            Constants.enumName.rawValue: variablesEnumName,
            Constants.variables.rawValue: loadVariables(),
            Constants.accessControl.rawValue: accessControl.rawValue
        ]
        return try templater.renderTemplate(at: variablesTemplateUrl, with: variablesContext)
    }
    
    func generateAccessor(accessorTemplatePath: String,
                          variablesEnumName: String,
                          accessorClassName: String,
                          accessControl: AccessControl) throws -> String {
        let templater = Templater()
        let accessorTemplateUrl = URL(fileURLWithPath: accessorTemplatePath)
        let accessorContext: [String: Any] = [
            Constants.className.rawValue: accessorClassName,
            Constants.enumName.rawValue: variablesEnumName,
            Constants.accessorInfos.rawValue: loadAccessorInfos(),
            Constants.accessControl.rawValue: accessControl.rawValue
        ]
        return try templater.renderTemplate(at: accessorTemplateUrl, with: accessorContext)
    }
    
    private func validate() throws {
        let duplicateVariables = Dictionary(grouping: datasource.toggles, by: \.variable)
            .filter { $1.count > 1 }
            .compactMap { String($0.0) }
            .map { String($0) }
        if duplicateVariables.count > 0 {
            throw LoaderError.foundDuplicateVariables(duplicateVariables)
        }
        
        let duplicatePropertyNames = Dictionary(grouping: datasource.toggles, by: \.computedPropertyName)
            .filter { $1.count > 1 }
            .compactMap { $0.0 }
        if duplicatePropertyNames.count > 0 {
            throw LoaderError.foundDuplicatePropertyNames(duplicatePropertyNames)
        }
    }
    
    private func loadVariables() -> [Constant] {
        datasource.toggles.map {
            Constant(name: $0.variable.codeVariableValue,
                     value: $0.variable)
        }
    }
    
    private func loadAccessorInfos() -> [AccessorInfo] {
        datasource.toggles.map { toggle in
            let constant = Constant(name: toggle.variable.codeVariableValue,
                                    value: toggle.variable)
            return AccessorInfo(variable: toggle.variable,
                                type: toggle.type,
                                propertyName: toggle.computedPropertyName,
                                constant: constant,
                                toggleType: toggle.toggleType)
        }
    }
}
