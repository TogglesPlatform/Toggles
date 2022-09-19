//  ToggleManager+CachingTests.swift

import XCTest
@testable import Toggles

final class ToggleManager_CachingTests: XCTestCase {

    let url = Bundle.toggles.url(forResource: "TestDatasource", withExtension: "json")!
    
    func test_hasNoOverrides() throws {
        let toggleManager = try ToggleManager(datasourceUrl: url)
        toggleManager.set(.int(42), for: "integer_toggle")
        XCTAssertFalse(toggleManager.hasOverrides)
    }
    
    func test_hasOverrides() throws {
        let toggleManager = try ToggleManager(mutableValueProvider: InMemoryValueProvider(),
                                              datasourceUrl: url)
        toggleManager.set(.int(42), for: "integer_toggle")
        XCTAssertTrue(toggleManager.hasOverrides)
    }
    
    func test_removeOverrides() throws {
        let toggleManager = try ToggleManager(mutableValueProvider: InMemoryValueProvider(),
                                              datasourceUrl: url)
        toggleManager.set(.int(42), for: "integer_toggle")
        toggleManager.removeOverrides()
        XCTAssertFalse(toggleManager.hasOverrides)
    }
    
    func test_getCachedValueAfterGet() throws {
        let toggleManager = try ToggleManager(datasourceUrl: url)
        let variable = "integer_toggle"
        XCTAssertNil(toggleManager.getCachedValue(for: variable))
        _ = toggleManager.value(for: variable)
        XCTAssertNotNil(toggleManager.getCachedValue(for: variable))
    }
    
    func test_getCachedValueAfterSet() throws {
        let toggleManager = try ToggleManager(mutableValueProvider: InMemoryValueProvider(),
                                              datasourceUrl: url)
        let variable = "integer_toggle"
        XCTAssertNil(toggleManager.getCachedValue(for: variable))
        toggleManager.set(.int(42), for: variable)
        XCTAssertNotNil(toggleManager.getCachedValue(for: variable))
    }
}
