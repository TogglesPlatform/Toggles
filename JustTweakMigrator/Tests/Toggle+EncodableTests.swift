//  Toggle+EncodableTests.swift

import XCTest
@testable import JustTweakMigrator

final class Toggle_CodableTests: XCTestCase {
        
    func test_codableBooleanToggle() throws {
        let toggle = Toggle(variable: "var",
                            value: .bool(true),
                            metadata: ToggleMetadata(description: "desc", group: "group", propertyName: "property"))
        let data = try! JSONEncoder().encode(toggle)
        let decodedToggle = try JSONDecoder().decode(Toggle.self, from: data)
        XCTAssertEqual(toggle, decodedToggle)
    }
    
    func test_codableIntegerToggle() throws {
        let toggle = Toggle(variable: "var",
                            value: .int(42),
                            metadata: ToggleMetadata(description: "desc", group: "group", propertyName: "property"))
        let data = try! JSONEncoder().encode(toggle)
        let decodedToggle = try JSONDecoder().decode(Toggle.self, from: data)
        XCTAssertEqual(toggle, decodedToggle)
    }
    
    func test_codableNumericToggle() throws {
        let toggle = Toggle(variable: "var",
                            value: .number(3.1416),
                            metadata: ToggleMetadata(description: "desc", group: "group", propertyName: "property"))
        let data = try! JSONEncoder().encode(toggle)
        let decodedToggle = try JSONDecoder().decode(Toggle.self, from: data)
        XCTAssertEqual(toggle, decodedToggle)
    }
    
    func test_codableStringToggle() throws {
        let toggle = Toggle(variable: "var",
                            value: .string("Hello World"),
                            metadata: ToggleMetadata(description: "desc", group: "group", propertyName: "property"))
        let data = try! JSONEncoder().encode(toggle)
        let decodedToggle = try JSONDecoder().decode(Toggle.self, from: data)
        XCTAssertEqual(toggle, decodedToggle)
    }
    
    func test_codableSecureToggle() throws {
        let toggle = Toggle(variable: "var",
                            value: .secure("secret"),
                            metadata: ToggleMetadata(description: "desc", group: "group", propertyName: "property"))
        let data = try! JSONEncoder().encode(toggle)
        let decodedToggle = try JSONDecoder().decode(Toggle.self, from: data)
        XCTAssertEqual(toggle, decodedToggle)
    }
}
