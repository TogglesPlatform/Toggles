//  ToggleManager+ReactingTests.swift

import XCTest
import Combine
import Toggles

class ToggleManager_ReactingTests: XCTestCase {

    private var cancellables: Set<AnyCancellable> = []
    
    func test_reacting() throws {
        let url = Bundle.toggles.url(forResource: "TestDatasource", withExtension: "json")!
        let remoteValueProvider = try MockRemoteValueProvider(jsonURL: url)
        let manager = try! ToggleManager(valueProviders: [remoteValueProvider], datasourceUrl: url)
        
        let integerValuePublisherExpectation = self.expectation(description: #function)
        let stringValuePublisherExpectation = self.expectation(description: #function)
        
        var integerValuePublisherCount = 0
        var stringValuePublisherCount = 0
        
        manager.publisher(for: "integer_toggle")
            .sink { value in
                integerValuePublisherCount += 1
                switch integerValuePublisherCount {
                case 1:
                    XCTAssertEqual(value, .int(42))
                case 2:
                    XCTAssertEqual(value, .int(43))
                    integerValuePublisherExpectation.fulfill()
                default:
                    XCTFail("Received more than 2 messages.")
                }
            }
            .store(in: &cancellables)
        
        manager.publisher(for: "string_toggle")
            .sink { value in
                stringValuePublisherCount += 1
                switch stringValuePublisherCount {
                case 1:
                    XCTAssertEqual(value, .string("Hello World"))
                case 2:
                    XCTAssertEqual(value, .string("Hello World!"))
                    stringValuePublisherExpectation.fulfill()
                default:
                    XCTFail("Received more than 2 messages.")
                }
            }
            .store(in: &cancellables)
        
        remoteValueProvider.fakeLoadLatestConfiguration {
            manager.reactToConfigurationChanges()
        }
        
        wait(for: [integerValuePublisherExpectation, stringValuePublisherExpectation], timeout: 1.0)
    }
}
