//  Generator.swift

import ArgumentParser
import Foundation

@main
struct Generator: ParsableCommand {
    
    @Option(name: .long, help: "The path of the template to use to generate the accessor.")
    var accessorTemplatePath: String
    
    @Option(name: .long, help: "The path of the template to use to generate the constants.")
    var constantsTemplatePath: String
    
    @Option(name: .long, help: "The name of the accessor class to generate.")
    var accessorClassName: String
    
    @Option(name: .long, help: "The name of the constants enum to generate.")
    var constantsEnumName: String
    
    @Option(name: .long, help: "The path of the datas ource to use.")
    var dataSourcePath: String
    
    @Option(name: .long, help: "The path to the folder to write the output to.")
    var outputPath: String
    
    enum Constants: String {
        case className
        case enumName
        case accessorInfos
        case constants
        case swift
    }
    
    mutating func run() throws {
        let dataSourceUrl = URL(fileURLWithPath: dataSourcePath)
        let dataSourceLoader = try DataSourceLoader(jsonURL: dataSourceUrl)
        
        let constants = try dataSourceLoader.loadConstants()
        let constantsContent = try generateConstants(constants: constants)
        try saveConstants(constantsContent)
        
        let accessorInfos = dataSourceLoader.loadAccessorInfos()
        let accessorContent = try generateAccessor(accessorInfos: accessorInfos)
        try saveAccessor(accessorContent)
    }
    
    private func generateConstants(constants: [Constant]) throws -> String {
        let templater = Templater()
        let constantsTemplateUrl = URL(fileURLWithPath: constantsTemplatePath)
        let constantsContext: [String: Any] = [
            Constants.enumName.rawValue: constantsEnumName,
            Constants.constants.rawValue: constants
        ]
        return try templater.renderTemplate(at: constantsTemplateUrl, with: constantsContext)
    }
    
    private func generateAccessor(accessorInfos: [AccessorInfo]) throws -> String {
        let templater = Templater()
        let accessorTemplateUrl = URL(fileURLWithPath: accessorTemplatePath)
        let accessorContext: [String: Any] = [
            Constants.className.rawValue: accessorClassName,
            Constants.enumName.rawValue: constantsEnumName,
            Constants.accessorInfos.rawValue: accessorInfos
        ]
        return try templater.renderTemplate(at: accessorTemplateUrl, with: accessorContext)
    }
    
    private func saveConstants(_ content: Content) throws {
        let constantsFileName = URL(fileURLWithPath: outputPath)
            .appendingPathComponent(constantsEnumName)
            .appendingPathExtension(Constants.swift.rawValue)
        try Writer.write(content, to: constantsFileName)
    }
    
    private func saveAccessor(_ content: Content) throws {
        let accessorFileName = URL(fileURLWithPath: outputPath)
            .appendingPathComponent(accessorClassName)
            .appendingPathExtension(Constants.swift.rawValue)
        try Writer.write(content, to: accessorFileName)
    }
}
