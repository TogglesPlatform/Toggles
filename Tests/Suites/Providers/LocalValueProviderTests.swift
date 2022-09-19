//  LocalValueProviderTests.swift

import XCTest
@testable import Toggles

final class LocalValueProviderTests: XCTestCase {
    
    func test_name() throws {
        let url = Bundle.toggles.url(forResource: "TestDatasource", withExtension: "json")!
        let provider = try LocalValueProvider(jsonURL: url)
        XCTAssertEqual(provider.name, "Local")
    }
    
    func test_existingValue() throws {
        let url = Bundle.toggles.url(forResource: "TestDatasource", withExtension: "json")!
        let provider = try LocalValueProvider(jsonURL: url)
        XCTAssert(provider.value(for: "integer_toggle") != .none)
    }
    
    func test_missingValue() throws {
        let url = Bundle.toggles.url(forResource: "TestDatasource", withExtension: "json")!
        let provider = try LocalValueProvider(jsonURL: url)
        XCTAssertEqual(provider.value(for: "non_existing_variable"), .none)
    }
    
    func test_duplicatesInDatasourceNotAllowed() throws {
        let url = Bundle.toggles.url(forResource: "TestDatasourceWithDuplicateVariables", withExtension: "json")!
        XCTAssertThrowsError(try LocalValueProvider(jsonURL: url)) { error in
            XCTAssertEqual(error as! TogglesValidator.LoaderError, TogglesValidator.LoaderError.foundDuplicateVariables(["boolean_toggle", "integer_toggle"]))
        }
    }
}
