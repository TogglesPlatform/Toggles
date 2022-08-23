import XCTest
@testable import Toggles

final class ModelsTests: XCTestCase {
    
    private let booleanToggle = Toggle(variable: "boolean_toggle", value: .bool(value: true))
    private let integerToggle = Toggle(variable: "integer_toggle", value: .int(value: 42))
    private let numericalToggle = Toggle(variable: "numerical_toggle", value: .number(value: 3.1416))
    private let stringToggle = Toggle(variable: "string_toggle", value: .string(value: "Hello World"))
    
    private func makeToggles() -> [Toggle] {
        [
            booleanToggle,
            integerToggle,
            numericalToggle,
            stringToggle
        ]
    }
    
    private let booleanToggleMetadata = ToggleMetadata(variable: "boolean_toggle", description: "Boolean toggle", group: "group_1")
    private let integerToggleMetadata = ToggleMetadata(variable: "integer_toggle", description: "Integer toggle", group: "group_1")
    private let numericalToggleMetadata = ToggleMetadata(variable: "numerical_toggle", description: "Numerical toggle", group: "group_2")
    private let stringToggleMetadata = ToggleMetadata(variable: "string_toggle", description: "String toggle", group: "group_2")
    
    private func makeMetadata() -> [ToggleMetadata] {
        [
            booleanToggleMetadata,
            integerToggleMetadata,
            numericalToggleMetadata,
            stringToggleMetadata
        ]
    }
    
    func test_contract() throws {
        let url = Bundle.toggles.url(forResource: "contract", withExtension: "json")!
        let data = try Data(contentsOf: url)
        let dataSourceFromFile = try JSONDecoder().decode(DataSource.self, from: data)
        let targetDataSource = DataSource(toggles: makeToggles(), metadata: makeMetadata())
        XCTAssertEqual(dataSourceFromFile, targetDataSource)
    }
    
    func test_toggle_bool_accessor() throws {
        XCTAssertEqual(booleanToggle.value.boolValue, true)
        XCTAssertNil(integerToggle.value.boolValue)
        XCTAssertNil(numericalToggle.value.boolValue)
        XCTAssertNil(stringToggle.value.boolValue)
    }
    
    func test_toggle_int_accessor() throws {
        XCTAssertNil(booleanToggle.value.intValue)
        XCTAssertEqual(integerToggle.value.intValue, 42)
        XCTAssertNil(numericalToggle.value.intValue)
        XCTAssertNil(stringToggle.value.intValue)
    }
    
    func test_toggle_double_accessor() throws {
        XCTAssertNil(booleanToggle.value.doubleValue)
        XCTAssertNil(integerToggle.value.doubleValue)
        XCTAssertEqual(numericalToggle.value.doubleValue, 3.1416)
        XCTAssertNil(stringToggle.value.doubleValue)
    }
    
    func test_toggle_string_accessor() throws {
        XCTAssertNil(booleanToggle.value.stringValue)
        XCTAssertNil(integerToggle.value.stringValue)
        XCTAssertNil(numericalToggle.value.stringValue)
        XCTAssertEqual(stringToggle.value.stringValue, "Hello World")
    }
}
