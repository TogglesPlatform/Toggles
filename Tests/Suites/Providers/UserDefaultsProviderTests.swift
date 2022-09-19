//  UserDefaultsProviderTests.swift

import XCTest
import Toggles

final class UserDefaultsProviderTests: XCTestCase {

    private var userDefaultsProvider: UserDefaultsProvider!
    
    override func setUp() {
        super.setUp()
        let userDefaults = UserDefaults(suiteName: "testSuite")!
        userDefaultsProvider = UserDefaultsProvider(userDefaults: userDefaults)
    }

    override func tearDown() {
        userDefaultsProvider.deleteAll()
        userDefaultsProvider = nil
        super.tearDown()
    }
    
    func test_name() {
        XCTAssertEqual(userDefaultsProvider.name, "UserDefaults")
    }

    func test_set() {
        let variable = "test_variable"
        XCTAssertEqual(userDefaultsProvider.value(for: variable), .none)
        userDefaultsProvider.set(.int(42), for: variable)
        XCTAssertEqual(userDefaultsProvider.value(for: variable), .int(42))
    }
    
    func test_delete() {
        let variable = "test_variable"
        userDefaultsProvider.set(.int(42), for: variable)
        userDefaultsProvider.delete(variable)
        XCTAssertEqual(userDefaultsProvider.value(for: variable), .none)
    }
    
    func test_deleteAll() {
        let variable1 = "test_variable_1"
        let variable2 = "test_variable_2"
        userDefaultsProvider.set(.int(42), for: variable1)
        userDefaultsProvider.set(.string("Hello World"), for: variable2)
        userDefaultsProvider.deleteAll()
        XCTAssertEqual(userDefaultsProvider.value(for: variable1), .none)
        XCTAssertEqual(userDefaultsProvider.value(for: variable2), .none)
    }
    
    func test_variablesAfterSet() {
        let variable1 = "test_variable_1"
        let variable2 = "test_variable_2"
        userDefaultsProvider.set(.int(42), for: variable1)
        userDefaultsProvider.set(.string("Hello World"), for: variable2)
        let variables = userDefaultsProvider.variables
        XCTAssertEqual(variables.count, 2)
        XCTAssert(variables.contains(variable1))
        XCTAssert(variables.contains(variable2))
    }
    
    func test_variablesAfterDelete() {
        let variable1 = "test_variable_1"
        let variable2 = "test_variable_2"
        userDefaultsProvider.set(.int(42), for: variable1)
        userDefaultsProvider.set(.string("Hello World"), for: variable2)
        userDefaultsProvider.delete(variable1)
        let variables = userDefaultsProvider.variables
        XCTAssertEqual(variables.count, 1)
        XCTAssert(variables.contains(variable2))
        userDefaultsProvider.delete(variable2)
        XCTAssertEqual(userDefaultsProvider.variables.count, 0)
    }
}
