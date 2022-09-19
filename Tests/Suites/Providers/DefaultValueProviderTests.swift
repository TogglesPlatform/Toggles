//  DefaultValueProviderTests.swift

import XCTest
@testable import Toggles

final class DefaultValueProviderTests: XCTestCase {
    
    func test_name() throws {
        let url = Bundle.toggles.url(forResource: "TestDatasource", withExtension: "json")!
        let provider = try DefaultValueProvider(jsonURL: url)
        XCTAssertEqual(provider.name, "Default")
    }
    
    func test_value() throws {
        let url = Bundle.toggles.url(forResource: "TestDatasource", withExtension: "json")!
        let provider = try DefaultValueProvider(jsonURL: url)
        XCTAssert(provider.value(for: "integer_toggle") != .none)
    }
    
    func test_duplicatesInDatasourceNotAllowed() throws {
        let url = Bundle.toggles.url(forResource: "TestDatasourceWithDuplicateVariables", withExtension: "json")!
        XCTAssertThrowsError(try DefaultValueProvider(jsonURL: url)) { error in
            XCTAssertEqual(error as! TogglesValidator.LoaderError, TogglesValidator.LoaderError.foundDuplicateVariables(["boolean_toggle", "integer_toggle"]))
        }
    }
}
