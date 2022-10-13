//  ConverterTests.swift

import XCTest
@testable import JustTweakMigrator

final class ConverterTests: XCTestCase {
    
    func test_convertDatasource() throws {
        let tweaksDatasource = TweaksDatasourceFactory.makeTestTweaksDatasource()
        let togglesDatasource = try Converter.convert(tweaksDatasource: tweaksDatasource)
        let toggles = [
            Toggle(variable: "variable_1",
                   value: .bool(true),
                   metadata: ToggleMetadata(description: "Var 1", group: "group_1", propertyName: "var1")),
            Toggle(variable: "variable_2",
                   value: .int(42),
                   metadata: ToggleMetadata(description: "Var 2", group: "group_1", propertyName: "var2")),
            Toggle(variable: "variable_3",
                   value: .number(3.1416),
                   metadata: ToggleMetadata(description: "Var 3", group: "group_2", propertyName: "var3")),
            Toggle(variable: "variable_4",
                   value: .string("Hello World"),
                   metadata: ToggleMetadata(description: "Var 4", group: "group_2", propertyName: "var4")),
            Toggle(variable: "variable_5",
                   value: .secure("__encrypted_value__"),
                   metadata: ToggleMetadata(description: "Var 5", group: "group_2", propertyName: "var5"))
        ]
        let expectedTogglesDatasource = TogglesDatasource(toggles: toggles)
        XCTAssertEqual(togglesDatasource, expectedTogglesDatasource)
    }
    
    func test_convertDatasourceFailsInCaseOfInvalidValue() throws {
        let tweaksDatasource = TweaksDatasourceFactory.makeTestTweaksDatasourceWithInvalidValue()
        XCTAssertThrowsError(try Converter.convert(tweaksDatasource: tweaksDatasource)) { error in
            XCTAssertEqual(error as! Converter.ConverterError, Converter.ConverterError.invalidValue)
        }
    }
    
    func test_convertDatasourceFailsInCaseOfDuplicates() throws {
        let tweaksDatasource = TweaksDatasourceFactory.makeTestTweaksDatasourceWithDuplicate()
        XCTAssertThrowsError(try Converter.convert(tweaksDatasource: tweaksDatasource)) { error in
            XCTAssertEqual(error as! TogglesValidator.LoaderError, TogglesValidator.LoaderError.foundDuplicateVariables(["variable_3"]))
        }
    }
}
