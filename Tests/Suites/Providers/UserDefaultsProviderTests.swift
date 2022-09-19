//  UserDefaultsProviderTests.swift

import XCTest
import Toggles

final class UserDefaultsProviderTests: XCTestCase {

    private var userDefaultsProvider: UserDefaultsProvider!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        let userDefaults = UserDefaults(suiteName: "testSuite")!
        userDefaultsProvider = UserDefaultsProvider(userDefaults: userDefaults)
    }

    override func tearDownWithError() throws {
        userDefaultsProvider.deleteAll()
        userDefaultsProvider = nil
        try super.tearDownWithError()
    }
    
    func test_name() {
        XCTAssertEqual(userDefaultsProvider.name, "UserDefaults")
    }

    func test_set() throws {
        let variable = "test_variable"
        XCTAssertEqual(userDefaultsProvider.value(for: variable), .none)
        userDefaultsProvider.set(.int(42), for: variable)
        XCTAssertEqual(userDefaultsProvider.value(for: variable), .int(42))
    }
    
    func test_delete() throws {
        let variable = "test_variable"
        userDefaultsProvider.set(.int(42), for: variable)
        userDefaultsProvider.delete(variable)
        XCTAssertEqual(userDefaultsProvider.value(for: variable), .none)
    }
    
    func test_deleteAll() throws {
        let variable1 = "test_variable_1"
        let variable2 = "test_variable_2"
        userDefaultsProvider.set(.int(42), for: variable1)
        userDefaultsProvider.set(.string("Hello World"), for: variable2)
        userDefaultsProvider.deleteAll()
        XCTAssertEqual(userDefaultsProvider.value(for: variable1), .none)
        XCTAssertEqual(userDefaultsProvider.value(for: variable2), .none)
    }
    
    func test_variablesAfterSet() throws {
        let variable1 = "test_variable_1"
        let variable2 = "test_variable_2"
        userDefaultsProvider.set(.int(42), for: variable1)
        userDefaultsProvider.set(.string("Hello World"), for: variable2)
        let variables = userDefaultsProvider.variables
        XCTAssertEqual(variables.count, 2)
        XCTAssert(variables.contains(variable1))
        XCTAssert(variables.contains(variable2))
    }
    
    func test_variablesAfterDelete() throws {
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
