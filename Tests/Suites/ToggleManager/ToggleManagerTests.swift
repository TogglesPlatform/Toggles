//  ToggleManagerTests.swift

import XCTest
import Toggles

final class ToggleManagerTests: XCTestCase {
    
    private var toggleManager: ToggleManager!
    
    override func tearDown() {
        toggleManager.removeOverrides()
        toggleManager = nil
        super.tearDown()
    }
    
    // MARK: - DefaultValueProvider
    
    func test_value() throws {
        let url = Bundle.toggles.url(forResource: "TestDatasource", withExtension: "json")!
        toggleManager = try ToggleManager(datasourceUrl: url)
        let variable = "integer_toggle"
        XCTAssertEqual(toggleManager.value(for: variable), Value.int(42))
    }
    
    // MARK: - ValueProviders & DefaultValueProvider
    
    func test_valueWithValueProviders() throws {
        let url = Bundle.toggles.url(forResource: "TestDatasource", withExtension: "json")!
        toggleManager = try ToggleManager(valueProviders: [MockSingleValueProvider(value: .int(42)),
                                                           MockSingleValueProvider(value: .int(108))],
                                          datasourceUrl: url)
        let variable = "integer_toggle"
        XCTAssertEqual(toggleManager.value(for: variable), Value.int(42))
    }
    
    // MARK: - MutableValueProvider & DefaultValueProvider
    
    func test_valueWithMutableValueProvider() throws {
        let url = Bundle.toggles.url(forResource: "TestDatasource", withExtension: "json")!
        let variable = "integer_toggle"
        let inMemoryValueProvider = InMemoryValueProvider(datasource: [variable : .int(420)])
        toggleManager = try ToggleManager(mutableValueProvider: inMemoryValueProvider, datasourceUrl: url)
        XCTAssertEqual(toggleManager.value(for: variable), Value.int(420))
    }
    
    func test_valueOverrideWithMutableValueProvider() throws {
        let url = Bundle.toggles.url(forResource: "TestDatasource", withExtension: "json")!
        toggleManager = try ToggleManager(mutableValueProvider: InMemoryValueProvider(), datasourceUrl: url)
        let variable = "integer_toggle"
        toggleManager.set(.int(108), for: variable)
        XCTAssertEqual(toggleManager.value(for: variable), Value.int(108))
        toggleManager.delete(variable)
    }
    
    func test_valueDeletionWithMutableValueProvider() throws {
        let url = Bundle.toggles.url(forResource: "TestDatasource", withExtension: "json")!
        toggleManager = try ToggleManager(mutableValueProvider: InMemoryValueProvider(), datasourceUrl: url)
        let variable = "integer_toggle"
        toggleManager.set(.int(108), for: variable)
        toggleManager.delete(variable)
        XCTAssertEqual(toggleManager.value(for: variable), Value.int(42))
    }
    
    // MARK: - MutableValueProvider & ValueProviders & DefaultValueProvider
    
    func test_valueOverrideWithMutableValueProviderAndValueProvider() throws {
        let url = Bundle.toggles.url(forResource: "TestDatasource", withExtension: "json")!
        toggleManager = try ToggleManager(mutableValueProvider: InMemoryValueProvider(),
                                          valueProviders: [MockSingleValueProvider(value: .int(108)),
                                                           MockSingleValueProvider(value: .int(420))],
                                          datasourceUrl: url)
        let variable = "integer_toggle"
        XCTAssertEqual(toggleManager.value(for: variable), Value.int(108))
        toggleManager.set(.int(1000), for: variable)
        XCTAssertEqual(toggleManager.value(for: variable), Value.int(1000))
        toggleManager.delete(variable)
    }
    
    func test_valueDeletionWithMutableValueProviderAndValueProvider() throws {
        let url = Bundle.toggles.url(forResource: "TestDatasource", withExtension: "json")!
        toggleManager = try ToggleManager(mutableValueProvider: InMemoryValueProvider(),
                                          valueProviders: [MockSingleValueProvider(value: .int(108)),
                                                           MockSingleValueProvider(value: .int(420))],
                                          datasourceUrl: url)
        let variable = "integer_toggle"
        toggleManager.set(.int(1000), for: variable)
        toggleManager.delete(variable)
        XCTAssertEqual(toggleManager.value(for: variable), Value.int(108))
    }
}
