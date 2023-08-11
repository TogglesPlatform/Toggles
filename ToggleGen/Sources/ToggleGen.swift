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
    var variablesStructName: String
    
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
                                                               variablesStructName: variablesStructName,
                                                               accessControl: .public)
        let accessorContent = try generator.generateAccessor(accessorTemplatePath: accessorTemplatePath,
                                                             variablesStructName: variablesStructName,
                                                             accessorClassName: accessorClassName,
                                                             accessControl: .public)
        let writer = Writer()
        try writer.saveVariables(variablesContent,
                                 outputPath: outputPath,
                                 variablesStructName: variablesStructName)
        try writer.saveAccessor(accessorContent,
                                outputPath: outputPath,
                                accessorClassName: accessorClassName)
    }
}
