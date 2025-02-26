//  GeneratorTests.swift

import XCTest
@testable import ToggleGen

final class GeneratorTests: XCTestCase {

    func test_variablesContent_accessControlOpen() throws {
        let datasourceUrl = Bundle.module.url(forResource: "TestDatasource", withExtension: "json")!
        let generator = try Generator(datasourceUrl: datasourceUrl)
        let variablesTemplateUrl = Bundle.module.path(forResource: "Variables", ofType: "stencil")!
        let generatedContent = try generator.generateVariables(variablesTemplatePath: variablesTemplateUrl,
                                                               variablesEnumName: "TestVariables",
                                                               accessControl: .open)
        let variablesUrl = Bundle.module.url(forResource: "TestVariables_open", withExtension: "txt")!
        let expectedContent = try String(contentsOf: variablesUrl)
        XCTAssertEqual(generatedContent, expectedContent)
    }

    func test_accessorContent_accessControlOpen() throws {
        let datasourceUrl = Bundle.module.url(forResource: "TestDatasource", withExtension: "json")!
        let generator = try Generator(datasourceUrl: datasourceUrl)
        let accessorTemplateUrl = Bundle.module.path(forResource: "Accessor", ofType: "stencil")!
        let generatedContent = try generator.generateAccessor(accessorTemplatePath: accessorTemplateUrl,
                                                              variablesEnumName: "TestVariables",
                                                              accessorClassName: "TestToggleAccessor",
                                                              accessControl: .open)
        let variablesUrl = Bundle.module.url(forResource: "TestToggleAccessor_open", withExtension: "txt")!
        let expectedContent = try String(contentsOf: variablesUrl)
        XCTAssertEqual(generatedContent, expectedContent)
    }

    func test_variablesContent_accessControlPublic() throws {
        let datasourceUrl = Bundle.module.url(forResource: "TestDatasource", withExtension: "json")!
        let generator = try Generator(datasourceUrl: datasourceUrl)
        let variablesTemplateUrl = Bundle.module.path(forResource: "Variables", ofType: "stencil")!
        let generatedContent = try generator.generateVariables(variablesTemplatePath: variablesTemplateUrl,
                                                               variablesEnumName: "TestVariables",
                                                               accessControl: .public)
        let variablesUrl = Bundle.module.url(forResource: "TestVariables_public", withExtension: "txt")!
        let expectedContent = try String(contentsOf: variablesUrl)
        XCTAssertEqual(generatedContent, expectedContent)
    }

    func test_givenAccessControlNil_whenGenerateVariables_thenAccessControlIsDefault() throws {
        let datasourceUrl = Bundle.module.url(forResource: "TestDatasource", withExtension: "json")!
        let generator = try Generator(datasourceUrl: datasourceUrl)
        let variablesTemplateUrl = Bundle.module.path(forResource: "Variables", ofType: "stencil")!
        let generatedContent = try generator.generateVariables(variablesTemplatePath: variablesTemplateUrl,
                                                               variablesEnumName: "TestVariables",
                                                               accessControl: nil)
        let variablesUrl = Bundle.module.url(forResource: "TestVariables_nil", withExtension: "txt")!
        let expectedContent = try String(contentsOf: variablesUrl)
        XCTAssertEqual(generatedContent, expectedContent)
    }

    func test_accessorContent_accessControlPublic() throws {
        let datasourceUrl = Bundle.module.url(forResource: "TestDatasource", withExtension: "json")!
        let generator = try Generator(datasourceUrl: datasourceUrl)
        let accessorTemplateUrl = Bundle.module.path(forResource: "Accessor", ofType: "stencil")!
        let generatedContent = try generator.generateAccessor(accessorTemplatePath: accessorTemplateUrl,
                                                              variablesEnumName: "TestVariables",
                                                              accessorClassName: "TestToggleAccessor",
                                                              accessControl: .public)
        let variablesUrl = Bundle.module.url(forResource: "TestToggleAccessor_public", withExtension: "txt")!
        let expectedContent = try String(contentsOf: variablesUrl)
        XCTAssertEqual(generatedContent, expectedContent)
    }

    func test_variablesContent_accessControlInternal() throws {
        let datasourceUrl = Bundle.module.url(forResource: "TestDatasource", withExtension: "json")!
        let generator = try Generator(datasourceUrl: datasourceUrl)
        let variablesTemplateUrl = Bundle.module.path(forResource: "Variables", ofType: "stencil")!
        let generatedContent = try generator.generateVariables(variablesTemplatePath: variablesTemplateUrl,
                                                               variablesEnumName: "TestVariables",
                                                               accessControl: .internal)
        let variablesUrl = Bundle.module.url(forResource: "TestVariables_internal", withExtension: "txt")!
        let expectedContent = try String(contentsOf: variablesUrl)
        XCTAssertEqual(generatedContent, expectedContent)
    }

    func test_accessorContent_accessControlInternal() throws {
        let datasourceUrl = Bundle.module.url(forResource: "TestDatasource", withExtension: "json")!
        let generator = try Generator(datasourceUrl: datasourceUrl)
        let accessorTemplateUrl = Bundle.module.path(forResource: "Accessor", ofType: "stencil")!
        let generatedContent = try generator.generateAccessor(accessorTemplatePath: accessorTemplateUrl,
                                                              variablesEnumName: "TestVariables",
                                                              accessorClassName: "TestToggleAccessor",
                                                              accessControl: .internal)
        let variablesUrl = Bundle.module.url(forResource: "TestToggleAccessor_internal", withExtension: "txt")!
        let expectedContent = try String(contentsOf: variablesUrl)
        XCTAssertEqual(generatedContent, expectedContent)
    }
    
    func test_givenAccessControlNil_whenGenerateAccessor_thenAccessControlIsDefault() throws {
        let datasourceUrl = Bundle.module.url(forResource: "TestDatasource", withExtension: "json")!
        let generator = try Generator(datasourceUrl: datasourceUrl)
        let accessorTemplateUrl = Bundle.module.path(forResource: "Accessor", ofType: "stencil")!
        let generatedContent = try generator.generateAccessor(accessorTemplatePath: accessorTemplateUrl,
                                                              variablesEnumName: "TestVariables",
                                                              accessorClassName: "TestToggleAccessor",
                                                              accessControl: nil)
        let variablesUrl = Bundle.module.url(forResource: "TestToggleAccessor_nil", withExtension: "txt")!
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
