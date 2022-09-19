//  TogglesValidatorTests.swift

import XCTest
@testable import Toggles

final class TogglesValidatorTests: XCTestCase {
    
    func test_validInput() throws {
        let groupedToggle = [
            "boolean_toggle": [Toggle(variable: "boolean_toggle", value: .bool(true), metadata: Metadata(description: "", group: ""))],
            "integer_toggle": [Toggle(variable: "integer_toggle", value: .int(42), metadata: Metadata(description: "", group: ""))]
        ]
        try TogglesValidator.validate(groupedToggle)
    }
    
    func test_invalidInput() throws {
        let groupedToggle = [
            "boolean_toggle": [
                Toggle(variable: "boolean_toggle", value: .bool(false), metadata: Metadata(description: "", group: "")),
                Toggle(variable: "boolean_toggle", value: .bool(true), metadata: Metadata(description: "", group: ""))
            ],
            "integer_toggle": [
                Toggle(variable: "integer_toggle", value: .int(42), metadata: Metadata(description: "", group: "")),
                Toggle(variable: "integer_toggle", value: .int(108), metadata: Metadata(description: "", group: ""))
            ],
            "string_toggle": [Toggle(variable: "string_toggle", value: .string("Hello World"), metadata: Metadata(description: "", group: ""))]
        ]
        XCTAssertThrowsError(try TogglesValidator.validate(groupedToggle)) { error in
            XCTAssertEqual(error as! TogglesValidator.LoaderError, TogglesValidator.LoaderError.foundDuplicateVariables(["boolean_toggle", "integer_toggle"]))
        }
    }
}
