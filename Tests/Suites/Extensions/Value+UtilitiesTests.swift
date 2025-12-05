//  Value+UtilitiesTests.swift

import XCTest
@testable import Toggles

final class Value_UtilitiesTests: XCTestCase {

    func test_booleanValueDescription() throws {
        XCTAssertEqual(Value.bool(true).description, "true")
    }
    
    func test_intValueDescription() throws {
        XCTAssertEqual(Value.int(42).description, "42")
    }
    
    func test_numberValueDescription() throws {
        XCTAssertEqual(Value.number(3.1416).description, "3.1416")
    }
    
    func test_stringValueDescription() throws {
        XCTAssertEqual(Value.string("Hello World").description, "Hello World")
    }
    
    func test_secureValueDescription() throws {
        XCTAssertEqual(Value.secure("secret").description, "secret")
    }
    
    func test_objectValueDescription() throws {
        XCTAssertEqual(Value.object(Object(map: ["var": .int(333)])).description,"{\"var\":333}")
    }
    
    func test_booleanValueTypeDescription() throws {
        XCTAssertEqual(Value.bool(true).typeDescription, "Bool")
    }
    
    func test_intValueTypeDescription() throws {
        XCTAssertEqual(Value.int(42).typeDescription, "Int")
    }
    
    func test_numberValueTypeDescription() throws {
        XCTAssertEqual(Value.number(3.1416).typeDescription, "Double")
    }
    
    func test_stringValueTypeDescription() throws {
        XCTAssertEqual(Value.string("Hello World").typeDescription, "String")
    }
    
    func test_secureValueTypeDescription() throws {
        XCTAssertEqual(Value.secure("secret").typeDescription, "String")
    }
    
    func test_objectValueTypeDescription() throws {
        XCTAssertEqual(Value.object(Object(map: [:])).typeDescription, "Object")
    }
    
    func test_booleanValueSFSybol() throws {
        XCTAssertEqual(Value.bool(true).sfSymbolId, "power")
    }
    
    func test_intValueSFSybol() throws {
        XCTAssertEqual(Value.int(42).sfSymbolId, "number")
    }
    
    func test_numberValueSFSybol() throws {
        XCTAssertEqual(Value.number(3.1416).sfSymbolId, "function")
    }
    
    func test_stringValueSFSybol() throws {
        XCTAssertEqual(Value.string("Hello World").sfSymbolId, "textformat.abc")
    }
    
    func test_secureValueSFSybol() throws {
        XCTAssertEqual(Value.secure("secret").sfSymbolId, "lock.fill")
    }
    
    func test_ObjectValueSFSybol() throws {
        XCTAssertEqual(Value.object(Object(map: [:])).sfSymbolId, "curlybraces")
    }
}
