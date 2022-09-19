//  ToggleObservableTests.swift

import XCTest
import Combine
import Toggles

final class ToggleObservableTests: XCTestCase {
    
    private var toggleManager: ToggleManager!
    private var cancellables: Set<AnyCancellable> = []
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        let url = Bundle.toggles.url(forResource: "TestDatasource", withExtension: "json")!
        toggleManager = try ToggleManager(mutableValueProvider: InMemoryValueProvider(),
                                          datasourceUrl: url,
                                          cypherConfiguration: CypherConfiguration.chaChaPoly)
    }
    
    override func tearDownWithError() throws {
        toggleManager = nil
        try super.tearDownWithError()
    }
    
    func test_boolObservable() throws {
        let variable = "boolean_toggle"
        let toggleObservable = ToggleObservable(manager: toggleManager, variable: variable)
        
        let valueExpectation = self.expectation(description: #function)
        var receiveValueCount = 0
        
        let rawValueExpectation = self.expectation(description: #function)
        var receiveRawValueCount = 0
        
        let newValue: Bool = false
        
        toggleObservable.$value
            .sink { value in
                receiveValueCount += 1
                switch receiveValueCount {
                case 1:
                    XCTAssertEqual(value, .bool(true))
                case 2:
                    XCTAssertEqual(value, .bool(newValue))
                    valueExpectation.fulfill()
                default:
                    XCTFail("Received more than 2 messages.")
                }
            }
            .store(in: &cancellables)
        
        toggleObservable.$boolValue
            .sink { value in
                receiveRawValueCount += 1
                switch receiveRawValueCount {
                case 1:
                    XCTAssertEqual(value, true)
                case 2:
                    XCTAssertEqual(value, newValue)
                    rawValueExpectation.fulfill()
                default:
                    XCTFail("Received more than 2 messages.")
                }
            }
            .store(in: &cancellables)
        
        toggleObservable.$intValue
            .sink { value in
                XCTAssertEqual(value, 0)
            }
            .store(in: &cancellables)
        
        toggleObservable.$numberValue
            .sink { value in
                XCTAssertEqual(value, 0.0)
            }
            .store(in: &cancellables)
        
        toggleObservable.$stringValue
            .sink { value in
                XCTAssertEqual(value, "")
            }
            .store(in: &cancellables)
        
        toggleObservable.$secureValue
            .sink { value in
                XCTAssertEqual(value, "")
            }
            .store(in: &cancellables)
        
        toggleManager.set(.bool(newValue), for: variable)
        
        wait(for: [rawValueExpectation, valueExpectation], timeout: 5.0)
    }
    
    func test_intObservable() throws {
        let variable = "integer_toggle"
        let toggleObservable = ToggleObservable(manager: toggleManager, variable: variable)
        
        let valueExpectation = self.expectation(description: #function)
        var receiveValueCount = 0
        
        let rawValueExpectation = self.expectation(description: #function)
        var receiveRawValueCount = 0
        
        let newValue: Int = 108
        
        toggleObservable.$value
            .sink { value in
                receiveValueCount += 1
                switch receiveValueCount {
                case 1:
                    XCTAssertEqual(value, .int(42))
                case 2:
                    XCTAssertEqual(value, .int(newValue))
                    valueExpectation.fulfill()
                default:
                    XCTFail("Received more than 2 messages.")
                }
            }
            .store(in: &cancellables)
        
        toggleObservable.$intValue
            .sink { value in
                receiveRawValueCount += 1
                switch receiveRawValueCount {
                case 1:
                    XCTAssertEqual(value, 42)
                case 2:
                    XCTAssertEqual(value, newValue)
                    rawValueExpectation.fulfill()
                default:
                    XCTFail("Received more than 2 messages.")
                }
            }
            .store(in: &cancellables)
        
        toggleObservable.$boolValue
            .sink { value in
                XCTAssertEqual(value, false)
            }
            .store(in: &cancellables)
        
        toggleObservable.$numberValue
            .sink { value in
                XCTAssertEqual(value, 0.0)
            }
            .store(in: &cancellables)
        
        toggleObservable.$stringValue
            .sink { value in
                XCTAssertEqual(value, "")
            }
            .store(in: &cancellables)
        
        toggleObservable.$secureValue
            .sink { value in
                XCTAssertEqual(value, "")
            }
            .store(in: &cancellables)
        
        toggleManager.set(.int(newValue), for: variable)
        
        wait(for: [rawValueExpectation, valueExpectation], timeout: 5.0)
    }
    
    func test_numericalObservable() throws {
        let variable = "numerical_toggle"
        let toggleObservable = ToggleObservable(manager: toggleManager, variable: variable)

        let valueExpectation = self.expectation(description: #function)
        var receiveValueCount = 0

        let rawValueExpectation = self.expectation(description: #function)
        var receiveRawValueCount = 0
        
        let newValue: Double = 108.42

        toggleObservable.$value
            .sink { value in
                receiveValueCount += 1
                switch receiveValueCount {
                case 1:
                    XCTAssertEqual(value, .number(3.1416))
                case 2:
                    XCTAssertEqual(value, .number(newValue))
                    valueExpectation.fulfill()
                default:
                    XCTFail("Received more than 2 messages.")
                }
            }
            .store(in: &cancellables)

        toggleObservable.$numberValue
            .sink { value in
                receiveRawValueCount += 1
                switch receiveRawValueCount {
                case 1:
                    XCTAssertEqual(value, 3.1416)
                case 2:
                    XCTAssertEqual(value, newValue)
                    rawValueExpectation.fulfill()
                default:
                    XCTFail("Received more than 2 messages.")
                }
            }
            .store(in: &cancellables)

        toggleObservable.$boolValue
            .sink { value in
                XCTAssertEqual(value, false)
            }
            .store(in: &cancellables)

        toggleObservable.$intValue
            .sink { value in
                XCTAssertEqual(value, 0)
            }
            .store(in: &cancellables)

        toggleObservable.$stringValue
            .sink { value in
                XCTAssertEqual(value, "")
            }
            .store(in: &cancellables)

        toggleObservable.$secureValue
            .sink { value in
                XCTAssertEqual(value, "")
            }
            .store(in: &cancellables)

        toggleManager.set(.number(newValue), for: variable)

        wait(for: [rawValueExpectation, valueExpectation], timeout: 5.0)
    }

    func test_stringObservable() throws {
        let variable = "string_toggle"
        let toggleObservable = ToggleObservable(manager: toggleManager, variable: variable)

        let valueExpectation = self.expectation(description: #function)
        var receiveValueCount = 0

        let rawValueExpectation = self.expectation(description: #function)
        var receiveRawValueCount = 0
        
        let newValue: String = "Ciao Mondo"

        toggleObservable.$value
            .sink { value in
                receiveValueCount += 1
                switch receiveValueCount {
                case 1:
                    XCTAssertEqual(value, .string("Hello World"))
                case 2:
                    XCTAssertEqual(value, .string(newValue))
                    valueExpectation.fulfill()
                default:
                    XCTFail("Received more than 2 messages.")
                }
            }
            .store(in: &cancellables)

        toggleObservable.$stringValue
            .sink { value in
                receiveRawValueCount += 1
                switch receiveRawValueCount {
                case 1:
                    XCTAssertEqual(value, "Hello World")
                case 2:
                    XCTAssertEqual(value, newValue)
                    rawValueExpectation.fulfill()
                default:
                    XCTFail("Received more than 2 messages.")
                }
            }
            .store(in: &cancellables)

        toggleObservable.$boolValue
            .sink { value in
                XCTAssertEqual(value, false)
            }
            .store(in: &cancellables)

        toggleObservable.$intValue
            .sink { value in
                XCTAssertEqual(value, 0)
            }
            .store(in: &cancellables)

        toggleObservable.$numberValue
            .sink { value in
                XCTAssertEqual(value, 0.0)
            }
            .store(in: &cancellables)

        toggleObservable.$secureValue
            .sink { value in
                XCTAssertEqual(value, "")
            }
            .store(in: &cancellables)

        toggleManager.set(.string(newValue), for: variable)

        wait(for: [rawValueExpectation, valueExpectation], timeout: 5.0)
    }

    func test_secureObservable() throws {
        let variable = "secure_toggle"
        let toggleObservable = ToggleObservable(manager: toggleManager, variable: variable)

        let valueExpectation = self.expectation(description: #function)
        var receiveValueCount = 0

        let rawValueExpectation = self.expectation(description: #function)
        var receiveRawValueCount = 0
        
        let newValue = "secret"

        toggleObservable.$value
            .sink { value in
                receiveValueCount += 1
                switch receiveValueCount {
                case 1:
                    XCTAssertEqual(value, .secure("€ncrypted"))
                case 2:
                    XCTAssertEqual(value, .secure(newValue))
                    valueExpectation.fulfill()
                default:
                    XCTFail("Received more than 2 messages.")
                }
            }
            .store(in: &cancellables)

        toggleObservable.$secureValue
            .sink { value in
                receiveRawValueCount += 1
                switch receiveRawValueCount {
                case 1:
                    XCTAssertEqual(value, "€ncrypted")
                case 2:
                    XCTAssertEqual(value, newValue)
                    rawValueExpectation.fulfill()
                default:
                    XCTFail("Received more than 2 messages.")
                }
            }
            .store(in: &cancellables)

        toggleObservable.$boolValue
            .sink { value in
                XCTAssertEqual(value, false)
            }
            .store(in: &cancellables)

        toggleObservable.$intValue
            .sink { value in
                XCTAssertEqual(value, 0)
            }
            .store(in: &cancellables)

        toggleObservable.$numberValue
            .sink { value in
                XCTAssertEqual(value, 0.0)
            }
            .store(in: &cancellables)

        toggleObservable.$stringValue
            .sink { value in
                XCTAssertEqual(value, "")
            }
            .store(in: &cancellables)

        toggleManager.set(.secure("secret"), for: variable)

        wait(for: [rawValueExpectation, valueExpectation], timeout: 5.0)
    }
}
