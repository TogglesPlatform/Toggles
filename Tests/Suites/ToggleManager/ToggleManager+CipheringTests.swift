//  ToggleManager+CipheringTests.swift

import XCTest
@testable import Toggles
import CryptoKit

final class ToggleManager_CipheringTests: XCTestCase {

    let url = Bundle.toggles.url(forResource: "TestDatasource", withExtension: "json")!
    
    func test_writeValueWithNonSecureValue() throws {
        let toggleManager = try ToggleManager(datasourceUrl: url)
        let value = try toggleManager.writeValue(for: .int(42))
        XCTAssertEqual(value, .int(42))
    }
    
    func test_writeValueWithSecureValue() throws {
        let toggleManager = try ToggleManager(datasourceUrl: url,
                                              cipherConfiguration: CipherConfiguration.chaChaPoly)
        let value = try toggleManager.writeValue(for: .secure("secret"))
        XCTAssertFalse(value.secureValue!.isEmpty)
    }
    
    func test_writeValueWithSecureValueNoCipherConfiguration() throws {
        let toggleManager = try ToggleManager(datasourceUrl: url)
        XCTAssertThrowsError(try toggleManager.writeValue(for: .secure("secret"))) { error in
            XCTAssertEqual(error as! ToggleManager.FetchError, ToggleManager.FetchError.missingCipherConfiguration)
        }
    }
    
    func test_readValueWithNonSecureValue() throws {
        let toggleManager = try ToggleManager(datasourceUrl: url)
        let value = try toggleManager.readValue(for: .int(42))
        XCTAssertEqual(value, .int(42))
    }
    
    func test_readValueWithSecureValue() throws {
        let toggleManager = try ToggleManager(datasourceUrl: url,
                                              cipherConfiguration: CipherConfiguration.chaChaPoly)
        let value = try toggleManager.readValue(for: .secure("eDUxAQXW6dobqAMxhZIJLkyQKb8+36bFHc36eabacXDahMipVnGy/Q=="))
        XCTAssertEqual(value, .secure("Secure Value"))
    }
    
    func test_readValueWithSecureValueNoCipherConfiguration() throws {
        let toggleManager = try ToggleManager(datasourceUrl: url)
        XCTAssertThrowsError(try toggleManager.readValue(for: .secure("eDUxAQXW6dobqAMxhZIJLkyQKb8+36bFHc36eabacXDahMipVnGy/Q=="))) { error in
            XCTAssertEqual(error as! ToggleManager.FetchError, ToggleManager.FetchError.missingCipherConfiguration)
        }
    }
    
    func test_readValueWithEmptySecureValueAndIgnoreEmptyStringsEnabled() throws {
        let toggleManager = try ToggleManager(datasourceUrl: url,
                                              cipherConfiguration: CipherConfiguration.chaChaPolyWithIgnoreEmptyStrings)
        let value = try toggleManager.readValue(for: .secure(""))
        XCTAssertEqual(value, .secure(""))
    }
    
    func test_readValueWithEmptySecureValueAndIgnoreEmptyStringsDisabled() throws {
        let toggleManager = try ToggleManager(datasourceUrl: url,
                                              cipherConfiguration: CipherConfiguration.chaChaPoly)
        XCTAssertThrowsError(try toggleManager.readValue(for: .secure(""))) { error in
            guard let cryptoKitError = error as? CryptoKitError else {
                XCTFail("Unexpected error type: \(type(of: error))")
                return
            }
            
            switch cryptoKitError {
            case .incorrectParameterSize:
                // The expected error
                break
            default:
                XCTFail("Unexpected error: \(cryptoKitError)")
            }
        }
    }
}
