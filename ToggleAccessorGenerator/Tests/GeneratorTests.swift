//  GeneratorTests.swift

import XCTest
@testable import ToogleAccessorGenerator

final class GeneratorTests: XCTestCase {

    func test_constantsContent() throws {
        let datasourceUrl = Bundle.module.url(forResource: "TestDatasource", withExtension: "json")!
        let generator = try Generator(datasourceUrl: datasourceUrl)
        let constantsTemplateUrl = Bundle.module.path(forResource: "Constants", ofType: "stencil")!
        let generatedContent = try generator.generateConstants(constantsTemplatePath: constantsTemplateUrl,
                                                               constantsEnumName: "TestConstants")
        let constantsUrl = Bundle.module.url(forResource: "TestConstants", withExtension: "txt")!
        let expectedContent = try String(contentsOf: constantsUrl)
        XCTAssertEqual(generatedContent, expectedContent)
    }
    
    func test_accessorContent() throws {
        let datasourceUrl = Bundle.module.url(forResource: "TestDatasource", withExtension: "json")!
        let generator = try Generator(datasourceUrl: datasourceUrl)
        let accessorTemplateUrl = Bundle.module.path(forResource: "Accessor", ofType: "stencil")!
        let generatedContent = try generator.generateAccessor(accessorTemplatePath: accessorTemplateUrl,
                                                              constantsEnumName: "TestConstants",
                                                              accessorClassName: "TestToggleAccessor")
        let constantsUrl = Bundle.module.url(forResource: "TestToggleAccessor", withExtension: "txt")!
        let expectedContent = try String(contentsOf: constantsUrl)
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
