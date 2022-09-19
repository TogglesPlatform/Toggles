//  String+BoolTests.swift

import XCTest
@testable import Toggles

final class String_BoolTests: XCTestCase {
    
    func test_boolValueTrueCases() throws {
        XCTAssertTrue("true".boolValue!)
        XCTAssertTrue("t".boolValue!)
        XCTAssertTrue("yes".boolValue!)
        XCTAssertTrue("y".boolValue!)
        XCTAssertTrue("1".boolValue!)
    }
    
    func test_boolValueFalseCases() throws {
        XCTAssertFalse("false".boolValue!)
        XCTAssertFalse("f".boolValue!)
        XCTAssertFalse("no".boolValue!)
        XCTAssertFalse("n".boolValue!)
        XCTAssertFalse("0".boolValue!)
    }
    
    func test_boolValueOtherCases() throws {
        XCTAssertNil("someOtherString".boolValue)
    }
}
