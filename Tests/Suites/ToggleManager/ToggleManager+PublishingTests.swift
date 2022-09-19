//  ToggleManager+PublishingTests.swift

import XCTest
import Combine
import Toggles

class ToggleManager_PublishingTests: XCTestCase {

    private var cancellables: Set<AnyCancellable> = []
    
    func test_publishers() throws {
        let url = Bundle.toggles.url(forResource: "TestDatasource", withExtension: "json")!
        let inMemoryProvider = InMemoryValueProvider()
        let manager = try! ToggleManager(mutableValueProvider: inMemoryProvider, datasourceUrl: url)
        
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
}
