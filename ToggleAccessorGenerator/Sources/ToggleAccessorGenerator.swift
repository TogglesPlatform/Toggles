//  ToggleAccessorGenerator.swift

import ArgumentParser
import Foundation

@main
struct ToggleAccessorGenerator: ParsableCommand {
    
    @Option(name: .long, help: "The path of the template to use to generate the constants.")
    var constantsTemplatePath: String
    
    @Option(name: .long, help: "The path of the template to use to generate the accessor.")
    var accessorTemplatePath: String
    
    @Option(name: .long, help: "The name of the constants enum to generate.")
    var constantsEnumName: String
    
    @Option(name: .long, help: "The name of the accessor class to generate.")
    var accessorClassName: String
    
    @Option(name: .long, help: "The path of the datas ource to use.")
    var datasourcePath: String
    
    @Option(name: .long, help: "The path to the folder to write the output to.")
    var outputPath: String
    
    mutating func run() throws {
        let datasourceUrl = URL(fileURLWithPath: datasourcePath)
        let generator = try Generator(datasourceUrl: datasourceUrl)
        let constantsContent = try generator.generateConstants(constantsTemplatePath: constantsTemplatePath,
                                                               constantsEnumName: constantsEnumName)
        let accessorContent = try generator.generateAccessor(accessorTemplatePath: accessorTemplatePath,
                                                             constantsEnumName: constantsEnumName,
                                                             accessorClassName: accessorClassName)
        let writer = Writer()
        try writer.saveConstants(constantsContent,
                                 outputPath: outputPath,
                                 constantsEnumName: constantsEnumName)
        try writer.saveAccessor(accessorContent,
                                outputPath: outputPath,
                                accessorClassName: accessorClassName)
    }
}
