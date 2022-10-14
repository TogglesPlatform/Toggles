//  ConvertDatasource.swift

import ArgumentParser
import Foundation

struct ConvertDatasource: ParsableCommand {
    
    @Option(name: .long, help: "The path to the JustTweak datasource.")
    var inputDatasourceFilePath: String

    @Option(name: .long, help: "The path to where save the Toggles datasource.")
    var outputDatasourceFilePath: String
    
    func run() throws {
        let tweaksDatasourceUrl = URL(fileURLWithPath: inputDatasourceFilePath)
        let data = try Data(contentsOf: tweaksDatasourceUrl)
        let tweaksDatasource = try JSONDecoder().decode(TweaksDatasource.self, from: data)
        
        print("*** Converting Tweaks Datasource ***")
        for (_, togglesByVariable) in tweaksDatasource.tweaks {
            for (variable, toggle) in togglesByVariable {
                print(variable + ": " + String(describing: toggle.value))
            }
        }
        
        let togglesDatasource = try Converter.convert(tweaksDatasource: tweaksDatasource)
        print("\n")
        print("*** Generated Toggles Datasource ***")
        for toggle in togglesDatasource.toggles {
            print(toggle.variable + ": " + String(describing: toggle.value))
        }
        
        let togglesDatasourceUrl = URL(fileURLWithPath: outputDatasourceFilePath)
        let encoder = JSONEncoder()
        encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
        let jsonData = try encoder.encode(togglesDatasource)
        try jsonData.write(to: togglesDatasourceUrl)
    }
}
