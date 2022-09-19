//  Value+AccessorsTests.swift

import XCTest
@testable import Toggles

final class Value_AccessorsTests: XCTestCase {
    
    private let factory = ToggleFactory()
    
    func test_toggleBoolAccessor() throws {
        XCTAssertNil(factory.noneToggle().value.boolValue)
        XCTAssertEqual(factory.booleanToggle(true).value.boolValue, true)
        XCTAssertNil(factory.integerToggle(42).value.boolValue)
        XCTAssertNil(factory.numericalToggle(3.1416).value.boolValue)
        XCTAssertNil(factory.stringToggle("Hello World").value.boolValue)
        XCTAssertNil(factory.secureToggle("secret").value.boolValue)
    }
    
    func test_toggleIntAccessor() throws {
        XCTAssertNil(factory.noneToggle().value.intValue)
        XCTAssertNil(factory.booleanToggle(true).value.intValue)
        XCTAssertEqual(factory.integerToggle(42).value.intValue, 42)
        XCTAssertNil(factory.numericalToggle(3.1416).value.intValue)
        XCTAssertNil(factory.stringToggle("Hello World").value.intValue)
        XCTAssertNil(factory.secureToggle("secret").value.intValue)
    }
    
    func test_toggleNumberAccessor() throws {
        XCTAssertNil(factory.noneToggle().value.numberValue)
        XCTAssertNil(factory.booleanToggle(true).value.numberValue)
        XCTAssertNil(factory.integerToggle(42).value.numberValue)
        XCTAssertEqual(factory.numericalToggle(3.1416).value.numberValue, 3.1416)
        XCTAssertNil(factory.stringToggle("Hello World").value.numberValue)
        XCTAssertNil(factory.secureToggle("secret").value.numberValue)
    }
    
    func test_toggleStringAccessor() throws {
        XCTAssertNil(factory.noneToggle().value.stringValue)
        XCTAssertNil(factory.booleanToggle(true).value.stringValue)
        XCTAssertNil(factory.integerToggle(42).value.stringValue)
        XCTAssertNil(factory.numericalToggle(3.1416).value.stringValue)
        XCTAssertEqual(factory.stringToggle("Hello World").value.stringValue, "Hello World")
        XCTAssertNil(factory.secureToggle("secret").value.stringValue)
    }
    
    func test_toggleSecureAccessor() throws {
        XCTAssertNil(factory.noneToggle().value.secureValue)
        XCTAssertNil(factory.booleanToggle(true).value.secureValue)
        XCTAssertNil(factory.integerToggle(42).value.secureValue)
        XCTAssertNil(factory.numericalToggle(3.1416).value.secureValue)
        XCTAssertNil(factory.stringToggle("Hello World").value.secureValue)
        XCTAssertEqual(factory.secureToggle("secret").value.secureValue, "secret")
    }
}
