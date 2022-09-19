//  InMemoryValueProviderTests.swift

import XCTest
import Toggles

final class InMemoryValueProviderTests: XCTestCase {

    private var inMemoryValueProvider: InMemoryValueProvider!
    
    override func setUp() {
        super.setUp()
        let datasource: [Variable: Value] = [
            "integer_toggle": .int(42),
            "string_toggle": .string("Hello World")
        ]
        inMemoryValueProvider = InMemoryValueProvider(datasource: datasource)
    }
    
    override func tearDown() {
        inMemoryValueProvider = nil
        super.tearDown()
    }
    
    func test_name() {
        XCTAssertEqual(inMemoryValueProvider.name, "InMemory")
    }
    
    func test_value() throws {
        XCTAssertEqual(inMemoryValueProvider.value(for: "integer_toggle"), .int(42))
        XCTAssertEqual(inMemoryValueProvider.value(for: "string_toggle"), .string("Hello World"))
    }
    
    func test_set() throws {
        inMemoryValueProvider.set(.int(108), for: "integer_toggle")
        XCTAssertEqual(inMemoryValueProvider.value(for: "integer_toggle"), .int(108))

    }
    
    func test_delete() throws {
        inMemoryValueProvider.delete("integer_toggle")
        XCTAssertEqual(inMemoryValueProvider.value(for: "integer_toggle"), .none)
    }
    
    func test_deleteAll() throws {
        inMemoryValueProvider.deleteAll()
        XCTAssertEqual(inMemoryValueProvider.value(for: "integer_toggle"), .none)
        XCTAssertEqual(inMemoryValueProvider.value(for: "string_toggle"), .none)
    }
    
    func test_variable() throws {
        let variables = Set(["integer_toggle", "string_toggle"])
        XCTAssertEqual(inMemoryValueProvider.variables, variables)
    }
}
