//  TogglesValidatorTests.swift

import XCTest
@testable import JustTweakMigrator

final class TogglesValidatorTests: XCTestCase {

    func test_validateNoDuplicates() throws {
        let toggles = [
            Toggle(variable: "variable_1",
                   value: .bool(true),
                   metadata: ToggleMetadata(description: "Var 1", group: "group_1", propertyName: "var1")),
            Toggle(variable: "variable_2",
                   value: .int(42),
                   metadata: ToggleMetadata(description: "Var 2", group: "group_1", propertyName: "var2")),
        ]
        XCTAssertNoThrow(try TogglesValidator.validate(toggles))
    }
    
    func test_validateDuplicates() throws {
        let toggles = [
            Toggle(variable: "variable_1",
                   value: .bool(true),
                   metadata: ToggleMetadata(description: "Var 1", group: "group_1", propertyName: "var1")),
            Toggle(variable: "variable_1",
                   value: .int(42),
                   metadata: ToggleMetadata(description: "Var 2", group: "group_1", propertyName: "var2")),
        ]
        XCTAssertThrowsError(try TogglesValidator.validate(toggles))
    }
}
