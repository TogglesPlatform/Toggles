//  ValueCacheTests.swift

import XCTest
@testable import Toggles

final class ValueCacheTests: XCTestCase {
    
    private var cache: ValueCache<Variable, Value>!

    override func setUp() {
        super.setUp()
        cache = ValueCache<Variable, Value>()
    }

    override func tearDown() {
        cache = nil
        super.tearDown()
    }

    func test_set() throws {
        let variable = "variable"
        let setValue = Value.int(42)
        XCTAssertNil(cache.value(forKey: variable))
        cache[variable] = setValue
        XCTAssertEqual(cache.value(forKey: variable), setValue)
    }
    
    func test_remove() throws {
        let variable = "variable"
        cache[variable] = .int(42)
        cache[variable] = nil
        XCTAssertNil(cache.value(forKey: variable))
    }
    
    func test_evict() throws {
        let variable = "variable"
        cache[variable] = .int(42)
        cache.evict()
        XCTAssertNil(cache.value(forKey: variable))
    }
}
