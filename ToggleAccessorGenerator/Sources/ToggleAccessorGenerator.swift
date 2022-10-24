//  ToggleAccessorGenerator.swift

import ArgumentParser
import Foundation

@main
struct ToggleAccessorGenerator: ParsableCommand {
    
    @Option(name: .long, help: "The path of the template to use to generate the variables.")
    var variablesTemplatePath: String
    
    @Option(name: .long, help: "The path of the template to use to generate the accessor.")
    var accessorTemplatePath: String
    
    @Option(name: .long, help: "The name of the variables enum to generate.")
    var variablesEnumName: String
    
    @Option(name: .long, help: "The name of the accessor class to generate.")
    var accessorClassName: String
    
    @Option(name: .long, help: "The path of the datas ource to use.")
    var datasourcePath: String
    
    @Option(name: .long, help: "The path to the folder to write the output to.")
    var outputPath: String
    
    mutating func run() throws {
        let datasourceUrl = URL(fileURLWithPath: datasourcePath)
        let generator = try Generator(datasourceUrl: datasourceUrl)
        let variablesContent = try generator.generateVariables(variablesTemplatePath: variablesTemplatePath,
                                                               variablesEnumName: variablesEnumName)
        let accessorContent = try generator.generateAccessor(accessorTemplatePath: accessorTemplatePath,
                                                             variablesEnumName: variablesEnumName,
                                                             accessorClassName: accessorClassName)
        let writer = Writer()
        try writer.saveVariables(variablesContent,
                                 outputPath: outputPath,
                                 variablesEnumName: variablesEnumName)
        try writer.saveAccessor(accessorContent,
                                outputPath: outputPath,
                                accessorClassName: accessorClassName)
    }
}
