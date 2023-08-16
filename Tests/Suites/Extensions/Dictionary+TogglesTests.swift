//  Dictionary+TogglesTests.swift

import XCTest
@testable import Toggles

final class Dictionary_TogglesTests: XCTestCase {
    
    func test_EmptyDictionaryConversion() {
        let emptyDictionary: [String: Any] = [:]
        
        XCTAssertTrue( (try emptyDictionary.togglesDataSource).isEmpty)
    }
    
    func test_UnsupportedValueTypeDictionaryConversion() {
        let invalidDictionary: [String: Any] = ["key": 4, "key2": [4,5]]
        
        XCTAssertThrowsError(try invalidDictionary.togglesDataSource) { error in
            XCTAssertEqual(error as? Dictionary.ToggleConversionError, .unsupportedValueType("Array<Int>"))
        }
    }
    
    func test_ValidDictionaryConversion() {
        let validDictionary: [String: Any] = [
            "key1": "string value",
            "key2": true,
            "key3": 123,
            "key4": 3.14
        ]
        
        do {
            let result = try validDictionary.togglesDataSource
            
            XCTAssertEqual(result["key1"], Toggles.Value.string("string value"))
            XCTAssertEqual(result["key2"], Toggles.Value.bool(true))
            XCTAssertEqual(result["key3"], Toggles.Value.int(123))
            XCTAssertEqual(result["key4"], Toggles.Value.number(3.14))
        } catch {
            XCTFail("Unexpected error: \(error)")
        }
    }
}
