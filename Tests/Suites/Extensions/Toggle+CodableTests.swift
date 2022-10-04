//  Toggle+CodableTests.swift

import XCTest
@testable import Toggles

final class Toggle_CodableTests: XCTestCase {
    
    private let factory = ToggleFactory()
    
    func test_contract() throws {
        let url = Bundle.toggles.url(forResource: "TestDatasource", withExtension: "json")!
        let data = try Data(contentsOf: url)
        let datasourceFromFile = try JSONDecoder().decode(Datasource.self, from: data)
        let targetDatasource = Datasource(toggles: factory.makeToggles())
        XCTAssertEqual(datasourceFromFile, targetDatasource)
    }
    
    func test_contractWithNoMetadata() throws {
        let url = Bundle.toggles.url(forResource: "TestDatasourceWithNoMetadata", withExtension: "json")!
        let data = try Data(contentsOf: url)
        let datasourceFromFile = try JSONDecoder().decode(Datasource.self, from: data)
        let targetDatasource = Datasource(toggles: factory.makeTogglesWithNoMetadata())
        XCTAssertEqual(datasourceFromFile, targetDatasource)
    }
    
    func test_codableBooleanToggle() throws {
        let toggle = Toggle(variable: "var", value: .bool(true), metadata: Metadata(description: "", group: ""))
        let data = try! JSONEncoder().encode(toggle)
        let decodedToggle = try JSONDecoder().decode(Toggle.self, from: data)
        XCTAssertEqual(toggle, decodedToggle)
    }
    
    func test_codableIntegerToggle() throws {
        let toggle = Toggle(variable: "var", value: .int(42), metadata: Metadata(description: "", group: ""))
        let data = try! JSONEncoder().encode(toggle)
        let decodedToggle = try JSONDecoder().decode(Toggle.self, from: data)
        XCTAssertEqual(toggle, decodedToggle)
    }
    
    func test_codableNumericToggle() throws {
        let toggle = Toggle(variable: "var", value: .number(3.1416), metadata: Metadata(description: "", group: ""))
        let data = try! JSONEncoder().encode(toggle)
        let decodedToggle = try JSONDecoder().decode(Toggle.self, from: data)
        XCTAssertEqual(toggle, decodedToggle)
    }
    
    func test_codableStringToggle() throws {
        let toggle = Toggle(variable: "var", value: .string("Hello World"), metadata: Metadata(description: "", group: ""))
        let data = try! JSONEncoder().encode(toggle)
        let decodedToggle = try JSONDecoder().decode(Toggle.self, from: data)
        XCTAssertEqual(toggle, decodedToggle)
    }
    
    func test_codableSecureToggle() throws {
        let toggle = Toggle(variable: "var", value: .secure("secret"), metadata: Metadata(description: "", group: ""))
        let data = try! JSONEncoder().encode(toggle)
        let decodedToggle = try JSONDecoder().decode(Toggle.self, from: data)
        XCTAssertEqual(toggle, decodedToggle)
    }
    
    // Note: Performance Test Baselines not available for Swift Packages
    // https://forums.swift.org/t/performance-test-baselines-not-available-for-swift-packages/45621
    
    func test_measureToggleCreation() {
        measure {
            _ = Datasource(toggles: factory.makeToggles(count: 10000))
        }
    }
    
    func test_measureToggleEncoding() {
        let datasource = Datasource(toggles: factory.makeToggles(count: 10000))
        measure {
            _ = try! JSONEncoder().encode(datasource)
        }
    }
    
    func test_measureToggleDecoding() {
        let datasource = Datasource(toggles: factory.makeToggles(count: 10000))
        let data = try! JSONEncoder().encode(datasource)
        measure {
            _ = try! JSONDecoder().decode(Datasource.self, from: data)
        }
    }
}
