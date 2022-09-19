//  ToggleManager+CypheringTests.swift

import XCTest
@testable import Toggles

final class ToggleManager_CypheringTests: XCTestCase {

    let url = Bundle.toggles.url(forResource: "TestDatasource", withExtension: "json")!
    
    func test_writeValueWithNonSecureValue() throws {
        let toggleManager = try ToggleManager(datasourceUrl: url)
        let value = try toggleManager.writeValue(for: .int(42))
        XCTAssertEqual(value, .int(42))
    }
    
    func test_writeValueWithSecureValue() throws {
        let toggleManager = try ToggleManager(datasourceUrl: url,
                                              cypherConfiguration: CypherConfiguration.chaChaPoly)
        let value = try toggleManager.writeValue(for: .secure("secret"))
        XCTAssertFalse(value.secureValue!.isEmpty)
    }
    
    func test_writeValueWithSecureValueNoCypherConfiguration() throws {
        let toggleManager = try ToggleManager(datasourceUrl: url)
        XCTAssertThrowsError(try toggleManager.writeValue(for: .secure("secret"))) { error in
            XCTAssertEqual(error as! ToggleManager.FetchError, ToggleManager.FetchError.missingCypherConfiguration)
        }
    }
    
    func test_readValueWithNonSecureValue() throws {
        let toggleManager = try ToggleManager(datasourceUrl: url)
        let value = try toggleManager.readValue(for: .int(42))
        XCTAssertEqual(value, .int(42))
    }
    
    func test_readValueWithSecureValue() throws {
        let toggleManager = try ToggleManager(datasourceUrl: url,
                                              cypherConfiguration: CypherConfiguration.chaChaPoly)
        let value = try toggleManager.readValue(for: .secure("eDUxAQXW6dobqAMxhZIJLkyQKb8+36bFHc36eabacXDahMipVnGy/Q=="))
        XCTAssertEqual(value, .secure("Secure Value"))
    }
    
    func test_readValueWithSecureValueNoCypherConfiguration() throws {
        let toggleManager = try ToggleManager(datasourceUrl: url)
        XCTAssertThrowsError(try toggleManager.readValue(for: .secure("eDUxAQXW6dobqAMxhZIJLkyQKb8+36bFHc36eabacXDahMipVnGy/Q=="))) { error in
            XCTAssertEqual(error as! ToggleManager.FetchError, ToggleManager.FetchError.missingCypherConfiguration)
        }
    }
}
