//  ObjectTests.swift

import XCTest
@testable import Toggles

final class ObjectTests: XCTestCase {
    func test_objectDecoding_withSupportedTypes() throws {
        let jsonString = """
        {
          "boolProperty": false,
          "intProperty": 420,
          "stringProperty": "mild",
          "doubleProperty": 13.5
        }
        """
        
        let object = try XCTUnwrap(decodeJSON(jsonString))
        let dictionary = object.map
        
        XCTAssertEqual(dictionary["boolProperty"]?.boolValue, false)
        XCTAssertEqual(dictionary["intProperty"]?.intValue, 420)
        XCTAssertEqual(dictionary["stringProperty"]?.stringValue, "mild")
        XCTAssertEqual(dictionary["doubleProperty"]?.numberValue, 13.5)
    }
    
    func test_objectDecoding_asType_withSupportedTypes_succeeds() throws {
        let jsonString = """
        {
          "boolProperty": false,
          "intProperty": 420,
          "stringProperty": "mild",
          "doubleProperty": 13.5
        }
        """
        
        let object = try XCTUnwrap(decodeJSON(jsonString))
        
        struct MyObject: Codable {
            let boolProperty: Bool
            let intProperty: Int
            let stringProperty: String
            let doubleProperty: Double
        }
        
        let myObject: MyObject = try XCTUnwrap(try object.asType())
        
        XCTAssertEqual(myObject.boolProperty, false)
        XCTAssertEqual(myObject.intProperty, 420)
        XCTAssertEqual(myObject.stringProperty, "mild")
        XCTAssertEqual(myObject.doubleProperty, 13.5)
    }
    
    func test_objectDecoding_withUnsupportedTypes_throws() throws {
        let jsonString = "{\"arrayProperty\": [false, true]}"
        
        XCTAssertThrowsError(try decodeJSON(jsonString)) { error in
            XCTAssertEqual(error is DecodingError, true)
        }
    }
    
    func test_objectDecoding_asType_withNotMatchedObject_throws() throws {
        let jsonString = "{\"boolProperty\": false}"
        
        let object = try XCTUnwrap(decodeJSON(jsonString))
        
        struct MyObject: Codable {
            let stringProperty: String
        }
        
        var myObject: MyObject?
        XCTAssertThrowsError(
            myObject = try object.asType()
        ) { error in
            XCTAssertNil(myObject)
            XCTAssertEqual(error is DecodingError, true)
        }
    }
    
    func test_objectDecoding_withEmptyKey_throws() throws {
        let jsonString = "{\"\": false}"
        
        XCTAssertThrowsError(try decodeJSON(jsonString)) { error in
            XCTAssertEqual(error is DecodingError, true)
        }
    }
    
    func test_emptyObjectDecoding_throws() throws {
        let jsonString = "{}"
        
        XCTAssertThrowsError(try decodeJSON(jsonString)) { error in
            XCTAssertEqual(error is DecodingError, true)
        }
    }
    
    // MARK: - Helpers
    
    private func decodeJSON(_ jsonString: String) throws -> Object? {
        let json = try XCTUnwrap(jsonString.data(using: .utf8))
        let decoder = JSONDecoder()
        return try decoder.decode(Object.self, from: json)
    }
}
