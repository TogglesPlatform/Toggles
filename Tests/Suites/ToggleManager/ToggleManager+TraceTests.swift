//  ToggleManager+TraceTests.swift

import XCTest
@testable import Toggles

final class ToggleManager_TraceTests: XCTestCase {
    
    private var toggleManager: ToggleManager!
    
    func test_trace() throws {
        let url = Bundle.toggles.url(forResource: "TestDatasource", withExtension: "json")!
        toggleManager = try ToggleManager(mutableValueProvider: InMemoryValueProvider(),
                                          valueProviders: [MockSingleValueProvider(value: .int(104)),
                                                           MockSingleValueProvider(value: .int(108))],
                                          datasourceUrl: url)
        let variable = "integer_toggle"
        toggleManager.set(.int(1), for: variable)
        let trace = toggleManager.stackTrace(for: variable)
        
        let inMemory = trace[0]
        XCTAssertEqual(inMemory.providerName, "InMemory")
        XCTAssertEqual(inMemory.value, .int(1))
        
        let mock1 = trace[1]
        XCTAssertEqual(mock1.providerName, "SingleValue (mock)")
        XCTAssertEqual(mock1.value, .int(104))
        
        let mock2 = trace[2]
        XCTAssertEqual(mock2.providerName, "SingleValue (mock)")
        XCTAssertEqual(mock2.value, .int(108))
        
        let `default` = trace[3]
        XCTAssertEqual(`default`.providerName, "Default")
        XCTAssertEqual(`default`.value, .int(42))
    }
}
