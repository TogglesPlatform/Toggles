//  Value+AccessorsTests.swift

import XCTest
@testable import Toggles

final class Value_AccessorsTests: XCTestCase {
    
    private let factory = ToggleFactory()
    
    func test_toggleBoolAccessor() throws {
        XCTAssertEqual(factory.booleanToggle(true).value.boolValue, true)
        XCTAssertNil(factory.integerToggle(42).value.boolValue)
        XCTAssertNil(factory.numericToggle(3.1416).value.boolValue)
        XCTAssertNil(factory.stringToggle("Hello World").value.boolValue)
        XCTAssertNil(factory.secureToggle("secret").value.boolValue)
        XCTAssertNil(factory.objetToggle(Object(map: ["var": .int(333)])).value.boolValue)
    }
    
    func test_toggleIntAccessor() throws {
        XCTAssertNil(factory.booleanToggle(true).value.intValue)
        XCTAssertEqual(factory.integerToggle(42).value.intValue, 42)
        XCTAssertNil(factory.numericToggle(3.1416).value.intValue)
        XCTAssertNil(factory.stringToggle("Hello World").value.intValue)
        XCTAssertNil(factory.secureToggle("secret").value.intValue)
        XCTAssertNil(factory.objetToggle(Object(map: ["var": .int(333)])).value.intValue)
    }
    
    func test_toggleNumberAccessor() throws {
        XCTAssertNil(factory.booleanToggle(true).value.numberValue)
        XCTAssertNil(factory.integerToggle(42).value.numberValue)
        XCTAssertEqual(factory.numericToggle(3.1416).value.numberValue, 3.1416)
        XCTAssertNil(factory.stringToggle("Hello World").value.numberValue)
        XCTAssertNil(factory.secureToggle("secret").value.numberValue)
        XCTAssertNil(factory.objetToggle(Object(map: ["var": .int(333)])).value.numberValue)
    }
    
    func test_toggleStringAccessor() throws {
        XCTAssertNil(factory.booleanToggle(true).value.stringValue)
        XCTAssertNil(factory.integerToggle(42).value.stringValue)
        XCTAssertNil(factory.numericToggle(3.1416).value.stringValue)
        XCTAssertEqual(factory.stringToggle("Hello World").value.stringValue, "Hello World")
        XCTAssertNil(factory.secureToggle("secret").value.stringValue)
        XCTAssertNil(factory.objetToggle(Object(map: ["var": .int(333)])).value.stringValue)
    }
    
    func test_toggleSecureAccessor() throws {
        XCTAssertNil(factory.booleanToggle(true).value.secureValue)
        XCTAssertNil(factory.integerToggle(42).value.secureValue)
        XCTAssertNil(factory.numericToggle(3.1416).value.secureValue)
        XCTAssertNil(factory.stringToggle("Hello World").value.secureValue)
        XCTAssertEqual(factory.secureToggle("secret").value.secureValue, "secret")
        XCTAssertNil(factory.objetToggle(Object(map: ["var": .int(333)])).value.secureValue)
    }
    
    func test_toggleObjectAccessor() throws {
        XCTAssertNil(factory.booleanToggle(true).value.objectValue)
        XCTAssertNil(factory.integerToggle(42).value.objectValue)
        XCTAssertNil(factory.numericToggle(3.1416).value.objectValue)
        XCTAssertNil(factory.stringToggle("Hello World").value.objectValue)
        XCTAssertNil(factory.secureToggle("secret").value.objectValue)
        XCTAssertEqual(
            factory.objetToggle(Object(map: ["var": .int(333)])).value.objectValue,
            Object(map: ["var": .int(333)])
        )
    }
}
