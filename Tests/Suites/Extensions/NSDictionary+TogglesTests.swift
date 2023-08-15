//  NSDictionary+TogglesTests.swift

import XCTest
@testable import Toggles

final class NSDictionary_TogglesTests: XCTestCase {
    
    func testEmptyNSDictionaryConversion() {
        let emptyNSDictionary: NSDictionary = [:]
        
        XCTAssertThrowsError(try emptyNSDictionary.convertToToggleDataSource()) { error in
            XCTAssertEqual(error as? NSDictionary.ToggleConversionError, .nsDictionaryEmpty)
        }
    }
    
    func testInvalidFormatNSDictionaryConversion() {
        let invalidNSDictionary: NSDictionary = ["key": [4,5]]
        
        XCTAssertThrowsError(try invalidNSDictionary.convertToToggleDataSource()) { error in
            XCTAssertEqual(error as? NSDictionary.ToggleConversionError, .nsDictionaryInvalidFormat)
        }
    }
    
    func testInvalidFormatNSDictionaryConversion_multipleValues() {
        let invalidNSDictionary: NSDictionary = ["key": 4, "key2": [4,5]]
        
        XCTAssertThrowsError(try invalidNSDictionary.convertToToggleDataSource()) { error in
            XCTAssertEqual(error as? NSDictionary.ToggleConversionError, .nsDictionaryInvalidFormat)
        }
    }
    
    func testValidNSDictionaryConversion() {
        let validNSDictionary: NSDictionary = [
            "key1": "string value",
            "key2": true,
            "key3": 123,
            "key4": 3.14
        ]
        
        do {
            let result = try validNSDictionary.convertToToggleDataSource()
            
            XCTAssertEqual(result["key1"], Toggles.Value.string("string value"))
            XCTAssertEqual(result["key2"], Toggles.Value.bool(true))
            XCTAssertEqual(result["key3"], Toggles.Value.int(123))
            XCTAssertEqual(result["key4"], Toggles.Value.number(3.14))
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
