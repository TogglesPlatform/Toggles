//  LocalValueProviderTests.swift

import XCTest
@testable import Toggles

final class LocalValueProviderTests: XCTestCase {
    
    func test_name() throws {
        let url = Bundle.toggles.url(forResource: "TestDatasource", withExtension: "json")!
        let provider = try LocalValueProvider(jsonUrl: url)
        XCTAssertEqual(provider.name, "Local")
    }
    
    func test_existingValue() throws {
        let url = Bundle.toggles.url(forResource: "TestDatasource", withExtension: "json")!
        let provider = try LocalValueProvider(jsonUrl: url)
        XCTAssert(provider.value(for: "integer_toggle") != .none)
    }
    
    func test_missingValue() throws {
        let url = Bundle.toggles.url(forResource: "TestDatasource", withExtension: "json")!
        let provider = try LocalValueProvider(jsonUrl: url)
        XCTAssertEqual(provider.value(for: "non_existing_variable"), .none)
    }
    
    func test_getAllValues() throws {
        let url = Bundle.toggles.url(forResource: "TestDatasource", withExtension: "json")!
        let provider = try LocalValueProvider(jsonUrl: url)
        
        let variable1 = "boolean_toggle"
        let variable2 = "integer_toggle"
        let variable3 = "numeric_toggle"
        let variable4 = "string_toggle"
        let variable5 = "secure_toggle"
        let secureValue = Value.secure("YXe+Ev76FbdwCeDCVpZNZ1RItWZwKTLXF3/Yi+x62n3JWbvPo6YK")
        let allValues = provider.getAllValues()
        
        XCTAssertEqual(allValues[variable1], Value.bool(true))
        XCTAssertEqual(allValues[variable2], Value.int(42))
        XCTAssertEqual(allValues[variable3], Value.number(3.1416))
        XCTAssertEqual(allValues[variable4], Value.string("Hello World"))
        XCTAssertEqual(allValues[variable5], secureValue)
        
        XCTAssert(allValues.count == 5)
    }
    
    func test_duplicatesInDatasourceNotAllowed() throws {
        let url = Bundle.toggles.url(forResource: "TestDatasourceWithDuplicateVariables", withExtension: "json")!
        XCTAssertThrowsError(try LocalValueProvider(jsonUrl: url)) { error in
            XCTAssertEqual(error as! TogglesValidator.LoaderError, TogglesValidator.LoaderError.foundDuplicateVariables(["boolean_toggle", "integer_toggle"]))
        }
    }
}
