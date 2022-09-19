//  ToggleManagerTests.swift

import XCTest
import Toggles

final class ToggleManagerTests: XCTestCase {
    
    private var userDefaultsProvider: UserDefaultsProvider!
    private var toggleManager: ToggleManager!
    
    override func setUp() {
        super.setUp()
        let userDefaults = UserDefaults(suiteName: "testSuite")!
        userDefaultsProvider = UserDefaultsProvider(userDefaults: userDefaults)
    }
    
    override func tearDown() {
        toggleManager.removeOverrides()
        toggleManager = nil
        userDefaultsProvider = nil
        super.tearDown()
    }
    
    // MARK: - DefaultValueProvider
    
    func test_valueOverrideNoEffect() throws {
        let url = Bundle.toggles.url(forResource: "TestDatasource", withExtension: "json")!
        toggleManager = try ToggleManager(datasourceUrl: url)
        let variable = "integer_toggle"
        XCTAssertEqual(toggleManager.value(for: variable), Value.int(42))
        toggleManager.set(.string("Hello World"), for: variable)
        XCTAssertEqual(toggleManager.value(for: variable), Value.int(42))
        toggleManager.delete(variable)
    }
    
    func test_valueDeletionNoEffect() throws {
        let url = Bundle.toggles.url(forResource: "TestDatasource", withExtension: "json")!
        toggleManager = try ToggleManager(datasourceUrl: url)
        let variable = "integer_toggle"
        toggleManager.delete(variable)
        XCTAssertEqual(toggleManager.value(for: variable), Value.int(42))
    }
    
    // MARK: - InMemoryValueProvider & DefaultValueProvider
    
    func test_valueOverrideWithInMemoryValueProvider() throws {
        let url = Bundle.toggles.url(forResource: "TestDatasource", withExtension: "json")!
        toggleManager = try ToggleManager(mutableValueProvider: InMemoryValueProvider(), datasourceUrl: url)
        let variable = "integer_toggle"
        toggleManager.set(.int(108), for: variable)
        XCTAssertEqual(toggleManager.value(for: variable), Value.int(108))
        toggleManager.delete(variable)
    }
    
    func test_valueDeletionWithInMemoryValueProvider() throws {
        let url = Bundle.toggles.url(forResource: "TestDatasource", withExtension: "json")!
        toggleManager = try ToggleManager(mutableValueProvider: InMemoryValueProvider(), datasourceUrl: url)
        let variable = "integer_toggle"
        toggleManager.set(.int(108), for: variable)
        toggleManager.delete(variable)
        XCTAssertEqual(toggleManager.value(for: variable), Value.int(42))
    }
    
    // MARK: - UserDefaultsValueProvider & DefaultValueProvider
    
    func test_valueOverrideWithUserDefaultValueProvider() throws {
        let url = Bundle.toggles.url(forResource: "TestDatasource", withExtension: "json")!
        toggleManager = try ToggleManager(mutableValueProvider: userDefaultsProvider, datasourceUrl: url)
        
        // avoiding cache on get
        let variable1 = "variable1"
        userDefaultsProvider.set(.string("Hello World"), for: variable1)
        XCTAssertEqual(toggleManager.value(for: variable1), Value.string("Hello World"))
        toggleManager.delete(variable1)
        
        // leveraging cache on get
        let variable2 = "variable2"
        toggleManager.set(.string("Hello World"), for: variable2)
        XCTAssertEqual(toggleManager.value(for: variable2), Value.string("Hello World"))
        toggleManager.delete(variable2)
    }
    
    func test_valueDeletionWithUserDefaultValueProvider() throws {
        let url = Bundle.toggles.url(forResource: "TestDatasource", withExtension: "json")!
        toggleManager = try ToggleManager(mutableValueProvider: userDefaultsProvider, datasourceUrl: url)
        let variable = "integer_toggle"
        toggleManager.set(.string("Hello World"), for: variable)
        toggleManager.delete(variable)
        XCTAssertEqual(toggleManager.value(for: variable), Value.int(42))
    }
    
    // MARK: - ValueProviders & DefaultValueProvider
    
    func test_valueOverrideWithValueProvidersNoEffect() throws {
        let url = Bundle.toggles.url(forResource: "TestDatasource", withExtension: "json")!
        toggleManager = try ToggleManager(valueProviders: [MockSingleValueProvider(value: .int(42)),
                                                           MockSingleValueProvider(value: .int(108))],
                                          datasourceUrl: url)
        let variable = "integer_toggle"
        XCTAssertEqual(toggleManager.value(for: variable), Value.int(42))
        toggleManager.set(.int(420), for: variable)
        XCTAssertEqual(toggleManager.value(for: variable), Value.int(42))
        toggleManager.delete(variable)
    }
    
    func test_valueDeletionWithValueProvidersNoEffect() throws {
        let url = Bundle.toggles.url(forResource: "TestDatasource", withExtension: "json")!
        toggleManager = try ToggleManager(valueProviders: [MockSingleValueProvider(value: .int(42)),
                                                           MockSingleValueProvider(value: .int(108))],
                                          datasourceUrl: url)
        let variable = "integer_toggle"
        toggleManager.delete(variable)
        XCTAssertEqual(toggleManager.value(for: variable), Value.int(42))
    }
    
    // MARK: - UserDefaultsValueProvider & ValueProvider
    
    func test_valueOverrideWithUserDefaultValueProviderAndValueProvider() throws {
        let url = Bundle.toggles.url(forResource: "TestDatasource", withExtension: "json")!
        toggleManager = try ToggleManager(mutableValueProvider: userDefaultsProvider,
                                          valueProviders: [MockSingleValueProvider(value: .int(108))],
                                          datasourceUrl: url)
        let variable = "integer_toggle"
        XCTAssertEqual(toggleManager.value(for: variable), Value.int(108))
        toggleManager.set(.string("Hello World"), for: variable)
        XCTAssertEqual(toggleManager.value(for: variable), Value.string("Hello World"))
        toggleManager.delete(variable)
    }
    
    func test_valueDeletionWithUserDefaultValueProviderAndValueProvider() throws {
        let url = Bundle.toggles.url(forResource: "TestDatasource", withExtension: "json")!
        toggleManager = try ToggleManager(mutableValueProvider: userDefaultsProvider,
                                          valueProviders: [MockSingleValueProvider(value: .int(108))],
                                          datasourceUrl: url)
        let variable = "integer_toggle"
        toggleManager.set(.string("Hello World"), for: variable)
        toggleManager.delete(variable)
        XCTAssertEqual(toggleManager.value(for: variable), Value.int(108))
    }
}
