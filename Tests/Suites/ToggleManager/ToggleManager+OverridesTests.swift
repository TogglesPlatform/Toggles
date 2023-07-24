//  ToggleManager+OverridesTests.swift

import XCTest
@testable import Toggles

final class ToggleManager_OverridesTests: XCTestCase {

    let url = Bundle.toggles.url(forResource: "TestDatasource", withExtension: "json")!
    
    func test_hasNoMutableValueProviderHenceNoOverrides() throws {
        let toggleManager = try ToggleManager(datasourceUrl: url)
        XCTAssertEqual(toggleManager.overrides, [])
    }
    
    func test_hasNoOverrides() throws {
        let toggleManager = try ToggleManager(mutableValueProvider: InMemoryValueProvider(),
                                              datasourceUrl: url)
        XCTAssertEqual(toggleManager.overrides, [])
    }
    
    func test_hasOverrides() throws {
        let variable = "integer_toggle"
        let toggleManager = try ToggleManager(mutableValueProvider: InMemoryValueProvider(),
                                              datasourceUrl: url)
        toggleManager.set(.int(42), for: variable)
        XCTAssertEqual(toggleManager.overrides, [variable])
        
    }
    
    func test_removeOverrides() throws {
        let toggleManager = try ToggleManager(mutableValueProvider: InMemoryValueProvider(),
                                              datasourceUrl: url)
        toggleManager.set(.int(42), for: "integer_toggle")
        toggleManager.removeOverrides()
        XCTAssertEqual(toggleManager.overrides, [])
    }
}
