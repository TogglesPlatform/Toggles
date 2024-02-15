//  ObjectTests.swift

import XCTest
@testable import Toggles

final class ObjectTests: XCTestCase {
    // MARK: - Decoding
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
    
    
    // MARK: - Encoding
    
    func test_objectEncoding_withBoolType() throws {
        let object = Object(map: ["boolProperty": .bool(false)])
        let data = try encodeObject(object)
        let jsonString = String(data: data, encoding: .utf8)
        XCTAssertEqual(jsonString, "{\"boolProperty\":false}")
    }
    
    func test_objectEncoding_withIntType() throws {
        let object = Object(map: ["intProperty": .int(420)])
        let data = try encodeObject(object)
        let jsonString = String(data: data, encoding: .utf8)
        XCTAssertEqual(jsonString, "{\"intProperty\":420}")
    }
    
    func test_objectEncoding_withStringType() throws {
        let object = Object(map: ["stringProperty": .string("mild")])
        let data = try encodeObject(object)
        let jsonString = String(data: data, encoding: .utf8)
        XCTAssertEqual(jsonString, "{\"stringProperty\":\"mild\"}")
    }
    
    func test_objectEncoding_withDoubleType() throws {
        let object = Object(map: ["doubleProperty": .number(13.5)])
        let data = try encodeObject(object)
        let jsonString = String(data: data, encoding: .utf8)
        XCTAssertEqual(jsonString, "{\"doubleProperty\":13.5}")
    }
    
    func test_emptyObjectEncoding_throws() throws {
        let object = Object(map: [:])
        XCTAssertThrowsError(try encodeObject(object)) { error in
            XCTAssertEqual(error is EncodingError, true)
        }
    }
    
    // MARK: Equatable
    
    func test_sameObjects_equals() {
        let firstMap: [Variable: ObjectSupportedType] = [
            "intProperty": .int(420),
            "boolProperty": .bool(false),
            "stringProperty": .string("heya"),
            "numberProperty": .number(13.5)
        ]
        let secondMap: [Variable: ObjectSupportedType] = [
            "intProperty": .int(420),
            "numberProperty": .number(13.5),
            "boolProperty": .bool(false),
            "stringProperty": .string("heya")
        ]
        let firstObject = Object(map: firstMap)
        let secondObject = Object(map: secondMap)
        
        XCTAssertTrue(firstObject == secondObject)
    }
    
    func test_sameObjects_doesNoEqual() {
        let firstMap: [Variable: ObjectSupportedType] = ["intProperty": .int(420)]
        let secondMap: [Variable: ObjectSupportedType] = ["intProperty": .int(422)]
        let firstObject = Object(map: firstMap)
        let secondObject = Object(map: secondMap)
        
        XCTAssertFalse(firstObject == secondObject)
    }
    
    // MARK: - Helpers
    
    private func decodeJSON(_ jsonString: String) throws -> Object? {
        let json = try XCTUnwrap(jsonString.data(using: .utf8))
        let decoder = JSONDecoder()
        return try decoder.decode(Object.self, from: json)
    }
    
    private func encodeObject(_ object: Object) throws -> Data {
        let encoder = JSONEncoder()
        return try encoder.encode(object)
    }
}
