//  ToggleGen.swift

import ArgumentParser
import Foundation

@main
struct ToggleGen: ParsableCommand {
    
    @Option(name: .long, help: "The path of the template to use to generate the variables.")
    var variablesTemplatePath: String
    
    @Option(name: .long, help: "The path of the template to use to generate the accessor.")
    var accessorTemplatePath: String
    
    @Option(name: .long, help: "The name of the variables enum to generate.")
    var variablesEnumName: String
    
    @Option(name: .long, help: "The name of the accessor class to generate.")
    var accessorClassName: String
    
    @Option(name: .long, help: "The path of the datas source to use.")
    var datasourcePath: String
    
    @Option(name: .long, help: "The path to the folder to write the ToggleAccessor file to.")
    var accessorOutputPath: String
    
    @Option(name: .long, help: "The path to the folder to write the ToggleVariables file to.")
    var variablesOutputPath: String

    @Option(name: .long, help: "Access control level for the variables enum.")
    var variablesAccessControl: String?

    @Option(name: .long, help: "Access control level for the accessor class.")
    var accessorAccessControl: String?

    mutating func run() throws {
        let datasourceUrl = URL(fileURLWithPath: datasourcePath)
        let generator = try Generator(datasourceUrl: datasourceUrl)

        let variablesAccessControl = try variablesAccessControl.flatMap { try AccessControl(value: $0) }
        let accessorAccessControl = try accessorAccessControl.flatMap { try AccessControl(value: $0) }

        let variablesContent = try generator.generateVariables(variablesTemplatePath: variablesTemplatePath,
                                                               variablesEnumName: variablesEnumName,
                                                               accessControl: variablesAccessControl)
        let accessorContent = try generator.generateAccessor(accessorTemplatePath: accessorTemplatePath,
                                                             variablesEnumName: variablesEnumName,
                                                             accessorClassName: accessorClassName,
                                                             accessControl: accessorAccessControl)
        let writer = Writer()
        try writer.saveAccessor(accessorContent,
                                outputPath: accessorOutputPath,
                                accessorClassName: accessorClassName)
        try writer.saveVariables(variablesContent,
                                 outputPath: variablesOutputPath,
                                 variablesEnumName: variablesEnumName)
        
    }
}
