//  GeneratorTests.swift

import XCTest
@testable import ToggleGen

final class GeneratorTests: XCTestCase {

    func test_variablesContent() throws {
        let datasourceUrl = Bundle.module.url(forResource: "TestDatasource", withExtension: "json")!
        let generator = try Generator(datasourceUrl: datasourceUrl)
        let variablesTemplateUrl = Bundle.module.path(forResource: "Variables", ofType: "stencil")!
        let generatedContent = try generator.generateVariables(variablesTemplatePath: variablesTemplateUrl,
                                                               variablesEnumName: "TestVariables")
        let variablesUrl = Bundle.module.url(forResource: "TestVariables", withExtension: "txt")!
        let expectedContent = try String(contentsOf: variablesUrl)
        XCTAssertEqual(generatedContent, expectedContent)
    }
    
    func test_accessorContent() throws {
        let datasourceUrl = Bundle.module.url(forResource: "TestDatasource", withExtension: "json")!
        let generator = try Generator(datasourceUrl: datasourceUrl)
        let accessorTemplateUrl = Bundle.module.path(forResource: "Accessor", ofType: "stencil")!
        let generatedContent = try generator.generateAccessor(accessorTemplatePath: accessorTemplateUrl,
                                                              variablesEnumName: "TestVariables",
                                                              accessorClassName: "TestToggleAccessor")
        let variablesUrl = Bundle.module.url(forResource: "TestToggleAccessor", withExtension: "txt")!
        let expectedContent = try String(contentsOf: variablesUrl)
        XCTAssertEqual(generatedContent, expectedContent)
    }
    
    func test_accessorDoesNotSupportDatasourceWithDuplicateVariables() throws {
        let datasourceUrl = Bundle.module.url(forResource: "TestDatasourceWithDuplicateVariables", withExtension: "json")!
        XCTAssertThrowsError(try Generator(datasourceUrl: datasourceUrl)) { error in
            XCTAssertEqual(error as? Generator.LoaderError, Generator.LoaderError.foundDuplicateVariables(["boolean_toggle"]))
        }
    }
    
    func test_accessorDoesNotSupportDatasourceWithDuplicatePropertyNames() throws {
        let datasourceUrl = Bundle.module.url(forResource: "TestDatasourceWithDuplicatePropertyNames", withExtension: "json")!
        XCTAssertThrowsError(try Generator(datasourceUrl: datasourceUrl)) { error in
            XCTAssertEqual(error as? Generator.LoaderError, Generator.LoaderError.foundDuplicatePropertyNames(["userDefinedBooleanToggle"]))
        }
    }
}
