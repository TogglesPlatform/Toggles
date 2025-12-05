//  ToggleManager+PublishingTests.swift

import XCTest
import Combine
@testable import Toggles

class ToggleManager_PublishingTests: XCTestCase {

    private var cancellables: Set<AnyCancellable> = []
    private let datasourceUrl = Bundle.toggles.url(forResource: "TestDatasource", withExtension: "json")!
    
    override func tearDown() {
        cancellables.removeAll()
        super.tearDown()
    }
    
    func test_publishers() throws {
        let inMemoryProvider = InMemoryValueProvider()
        let manager = try ToggleManager(mutableValueProvider: inMemoryProvider, datasourceUrl: datasourceUrl)
        
        let valueExpectation = self.expectation(description: #function)
        let cachedPublisherValueExpectation = self.expectation(description: #function)
        var publisherReceiveValueCount = 0
        var cachedPublisherReceiveValueCount = 0
        let variable = "integer_toggle"
        
        let newValue = Value.int(108)
        
        manager.publisher(for: variable)
            .sink { value in
                publisherReceiveValueCount += 1
                switch publisherReceiveValueCount {
                case 1:
                    XCTAssertEqual(value, .int(42))
                case 2:
                    XCTAssertEqual(value, newValue)
                    valueExpectation.fulfill()
                default:
                    XCTFail("Received more than 2 messages.")
                }
            }
            .store(in: &cancellables)
        
        manager.publisher(for: variable)
            .sink { value in
                cachedPublisherReceiveValueCount += 1
                switch cachedPublisherReceiveValueCount {
                case 1:
                    XCTAssertEqual(value, .int(42))
                case 2:
                    XCTAssertEqual(value, newValue)
                    cachedPublisherValueExpectation.fulfill()
                default:
                    XCTFail("Received more than 2 messages.")
                }
            }
            .store(in: &cancellables)
        
        manager.set(newValue, for: variable)
        
        wait(for: [valueExpectation, cachedPublisherValueExpectation], timeout: 5.0)
    }
    
    func test_publisherRemainsActiveAfterRemoveOverrides() throws {
        let manager = try ToggleManager(mutableValueProvider: InMemoryValueProvider(), datasourceUrl: datasourceUrl)
        let variable = "integer_toggle"
        
        var receivedValues: [Value] = []
        let expectation = XCTestExpectation(description: "Receive updated values")
        expectation.expectedFulfillmentCount = 3
        
        manager.publisher(for: variable)
            .sink { value in
                receivedValues.append(value)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        manager.set(.int(999), for: variable)
        manager.removeOverrides()
        manager.reactToConfigurationChanges()
        
        wait(for: [expectation], timeout: 1.0)
        
        XCTAssertEqual(receivedValues.count, 3)
        XCTAssertEqual(receivedValues[0], .int(42))
        XCTAssertEqual(receivedValues[1], .int(999))
        XCTAssertEqual(receivedValues[2], .int(42))
    }
    
    func test_publisherRemainsActiveAfterDelete() throws {
        let manager = try ToggleManager(mutableValueProvider: InMemoryValueProvider(), datasourceUrl: datasourceUrl)
        let variable = "string_toggle"
        
        var receivedValues: [Value] = []
        let expectation = XCTestExpectation(description: "Receive updated values")
        expectation.expectedFulfillmentCount = 3
        
        manager.publisher(for: variable)
            .sink { value in
                receivedValues.append(value)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        manager.set(.string("overridden"), for: variable)
        manager.delete(variable)
        manager.reactToConfigurationChanges()
        
        wait(for: [expectation], timeout: 1.0)
        
        XCTAssertEqual(receivedValues.count, 3)
        XCTAssertEqual(receivedValues[0], .string("Hello World"))
        XCTAssertEqual(receivedValues[1], .string("overridden"))
        XCTAssertEqual(receivedValues[2], .string("Hello World"))
    }
    
    func test_subjectReferencesPreservedAfterRemoveOverrides() throws {
        let manager = try ToggleManager(mutableValueProvider: InMemoryValueProvider(), datasourceUrl: datasourceUrl)
        let variable = "integer_toggle"
        
        _ = manager.publisher(for: variable)
        XCTAssertNotNil(manager.subjectsRefs[variable])
        
        manager.set(.int(999), for: variable)
        manager.removeOverrides()
        
        XCTAssertNotNil(manager.subjectsRefs[variable], "Subject should still exist after removeOverrides()")
    }
    
    func test_subjectReferencesPreservedAfterDelete() throws {
        let manager = try ToggleManager(mutableValueProvider: InMemoryValueProvider(), datasourceUrl: datasourceUrl)
        let variable = "integer_toggle"
        
        _ = manager.publisher(for: variable)
        XCTAssertNotNil(manager.subjectsRefs[variable])
        
        manager.set(.int(888), for: variable)
        manager.delete(variable)
        
        XCTAssertNotNil(manager.subjectsRefs[variable], "Subject should still exist after delete()")
    }
    
    func test_toggleObservableRemainsActiveAfterRemoveOverrides() throws {
        let manager = try ToggleManager(mutableValueProvider: InMemoryValueProvider(), datasourceUrl: datasourceUrl)
        let variable = "boolean_toggle"
        
        let observable = ToggleObservable(manager: manager, variable: variable)
        
        var receivedValues: [Bool?] = []
        let expectation = XCTestExpectation(description: "Receive updated bool values")
        expectation.expectedFulfillmentCount = 3
        
        observable.$boolValue
            .sink { boolValue in
                receivedValues.append(boolValue)
                expectation.fulfill()
            }
            .store(in: &cancellables)
        
        manager.set(.bool(false), for: variable)
        manager.removeOverrides()
        manager.reactToConfigurationChanges()
        
        wait(for: [expectation], timeout: 1.0)
        
        XCTAssertEqual(receivedValues.count, 3)
        XCTAssertEqual(receivedValues[0], true)
        XCTAssertEqual(receivedValues[1], false)
        XCTAssertEqual(receivedValues[2], true)
    }
}
