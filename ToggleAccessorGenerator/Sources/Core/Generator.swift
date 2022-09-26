//  Generator.swift

import Foundation

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

class Generator {
    
    private enum Constants: String {
        case className
        case enumName
        case accessorInfos
        case constants
    }
    
    enum LoaderError: Error, Equatable {
        case foundDuplicateVariables([Toggle.Variable])
        case foundDuplicatePropertyNames([String])
    }
    
    private let datasource: Datasource
    
    init(datasourceUrl: URL) throws {
        let content = try Data(contentsOf: datasourceUrl)
        datasource = try JSONDecoder().decode(Datasource.self, from: content)
        try validate()
    }
    
    func generateConstants(constantsTemplatePath: String, constantsEnumName: String) throws -> String {
        let templater = Templater()
        let constantsTemplateUrl = URL(fileURLWithPath: constantsTemplatePath)
        let constantsContext: [String: Any] = [
            Constants.enumName.rawValue: constantsEnumName,
            Constants.constants.rawValue: loadConstants()
        ]
        return try templater.renderTemplate(at: constantsTemplateUrl, with: constantsContext)
    }
    
    func generateAccessor(accessorTemplatePath: String, constantsEnumName: String, accessorClassName: String) throws -> String {
        let templater = Templater()
        let accessorTemplateUrl = URL(fileURLWithPath: accessorTemplatePath)
        let accessorContext: [String: Any] = [
            Constants.className.rawValue: accessorClassName,
            Constants.enumName.rawValue: constantsEnumName,
            Constants.accessorInfos.rawValue: loadAccessorInfos()
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
    
    private func loadConstants() -> [Constant] {
        datasource.toggles.map {
            Constant(name: $0.variable.codeConstantValue,
                     value: $0.variable)
        }
    }
    
    private func loadAccessorInfos() -> [AccessorInfo] {
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
