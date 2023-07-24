//  PersistentValueProviderTests.swift

import XCTest
import Toggles

final class PersistentValueProviderTests: XCTestCase {
    
    private var persistentValueProvider: PersistentValueProvider!
    
    override func setUp() {
        super.setUp()
        let userDefaults = UserDefaults(suiteName: "testSuite")!
        persistentValueProvider = PersistentValueProvider(userDefaults: userDefaults)
    }
    
    override func tearDown() {
        persistentValueProvider.deleteAll()
        persistentValueProvider = nil
        super.tearDown()
    }
    
    func test_name() {
        XCTAssertEqual(persistentValueProvider.name, "Persistent")
    }
    
    func test_set() {
        let variable = "test_variable"
        XCTAssertNil(persistentValueProvider.value(for: variable))
        persistentValueProvider.set(.int(42), for: variable)
        XCTAssertEqual(persistentValueProvider.value(for: variable), .int(42))
    }
    
    func test_delete() {
        let variable = "test_variable"
        persistentValueProvider.set(.int(42), for: variable)
        persistentValueProvider.delete(variable)
        XCTAssertNil(persistentValueProvider.value(for: variable))
    }
    
    func test_deleteAll() {
        let variable1 = "test_variable_1"
        let variable2 = "test_variable_2"
        persistentValueProvider.set(.int(42), for: variable1)
        persistentValueProvider.set(.string("Hello World"), for: variable2)
        persistentValueProvider.deleteAll()
        XCTAssertNil(persistentValueProvider.value(for: variable1))
        XCTAssertNil(persistentValueProvider.value(for: variable2))
    }
    
    func test_variablesAfterSet() {
        let variable1 = "test_variable_1"
        let variable2 = "test_variable_2"
        persistentValueProvider.set(.int(42), for: variable1)
        persistentValueProvider.set(.string("Hello World"), for: variable2)
        let variables = persistentValueProvider.variables
        XCTAssertEqual(variables.count, 2)
        XCTAssert(variables.contains(variable1))
        XCTAssert(variables.contains(variable2))
    }
    
    func test_variablesAfterDelete() {
        let variable1 = "test_variable_1"
        let variable2 = "test_variable_2"
        persistentValueProvider.set(.int(42), for: variable1)
        persistentValueProvider.set(.string("Hello World"), for: variable2)
        persistentValueProvider.delete(variable1)
        let variables = persistentValueProvider.variables
        XCTAssertEqual(variables.count, 1)
        XCTAssert(variables.contains(variable2))
        persistentValueProvider.delete(variable2)
        XCTAssertEqual(persistentValueProvider.variables.count, 0)
    }
}
