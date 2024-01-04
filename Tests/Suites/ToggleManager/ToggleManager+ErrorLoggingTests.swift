//  ToggleManager+ErrorLogging.swift

@testable import Toggles
import XCTest

final class ToggleManager_ErrorLoggingTests: XCTestCase {
    private var toggleManager: ToggleManager!
    private var mockErrorLogger: myErrorLogger = myErrorLogger()
    
    override func tearDown() {
        toggleManager.removeOverrides()
        toggleManager = nil
        mockErrorLogger = myErrorLogger()
        super.tearDown()
    }
    
    final private class myErrorLogger: Logger {
        public var loggedMessages: [ToggleError] = []
        
        func log(_ error: ToggleError) {
            loggedMessages.append(error)
        }
    }
    
    func test_fallbackToDefaultValue_WhenOtherValueProviderValueIsADifferentType_isLogged() throws {
        let url = Bundle.toggles.url(forResource: "TestDatasource", withExtension: "json")!
        let invalidValue = Value.string("hello world")
        let valueProvider = MockSingleValueProvider(value: invalidValue)
        toggleManager = try ToggleManager(valueProviders: [MockSingleValueProvider(value: invalidValue)], datasourceUrl: url, logger: mockErrorLogger, options: [.skipInvalidValueTypes])
        let variable = "integer_toggle"
        XCTAssertEqual(toggleManager.value(for: variable), Value.int(42))
        
        XCTAssertTrue(mockErrorLogger.loggedMessages.contains { error in
            if case .invalidValueType(let varName, let value, let provider) = error {
                return varName == variable &&
                       value == invalidValue &&
                provider.name == valueProvider.name
            }
            return false
        })
        
        XCTAssertEqual(mockErrorLogger.loggedMessages.count, 1)
    }

    func test_fallbackToDefaultValue_WhenMultipleOtherValueProviderValuesAreDifferentTypes_isLogged() throws {
        let url = Bundle.toggles.url(forResource: "TestDatasource", withExtension: "json")!
        let invalidValue1 = Value.string("hello world")
        let invalidValue2 = Value.bool(true)
        toggleManager = try ToggleManager(valueProviders: [MockSingleValueProvider(value: invalidValue1), MockSingleValueProvider(value: invalidValue2)], datasourceUrl: url, logger: mockErrorLogger, options: [.skipInvalidValueTypes])
        let variable = "integer_toggle"
        XCTAssertEqual(toggleManager.value(for: variable), Value.int(42))
        
        XCTAssertTrue(mockErrorLogger.loggedMessages.contains { error in
            if case .invalidValueType(let varName, let value, let provider) = error {
                return varName == variable &&
                       value == invalidValue1 &&
                provider.name == "SingleValue (mock)"
            }
            return false
        })
        
        XCTAssertTrue(mockErrorLogger.loggedMessages.contains { error in
            if case .invalidValueType(let varName, let value, let provider) = error {
                return varName == variable &&
                       value == invalidValue2 &&
                provider.name == "SingleValue (mock)"
            }
            return false
        })
        XCTAssertEqual(mockErrorLogger.loggedMessages.count, 2)
    }

    func test_fallbackToOtherValidValue_WhenOneValueProviderValueIsADifferentType_isLogged() throws {
        let url = Bundle.toggles.url(forResource: "TestDatasource", withExtension: "json")!
        let invalidValue = Value.string("hello world")
        toggleManager = try ToggleManager(valueProviders: [MockSingleValueProvider(value: invalidValue), MockSingleValueProvider(value: .int(333))], datasourceUrl: url, logger: mockErrorLogger, options: [.skipInvalidValueTypes])
        let variable = "integer_toggle"
        XCTAssertEqual(toggleManager.value(for: variable), Value.int(333))
        
        XCTAssertTrue(mockErrorLogger.loggedMessages.contains { error in
            if case .invalidValueType(let varName, let value, let provider) = error {
                return varName == variable &&
                       value == invalidValue &&
                provider.name == "SingleValue (mock)"
            }
            return false
        })
        
        XCTAssertEqual(mockErrorLogger.loggedMessages.count, 1)
    }

    func test_fallbackToDefaultValue_WhenOtherValueProviderHasAnInvalidSecureValue_isLogged() throws {
        let url = Bundle.toggles.url(forResource: "TestDatasource", withExtension: "json")!
        let invalidValue = Value.secure("my unencrypted string")
        toggleManager = try ToggleManager(valueProviders: [MockSingleValueProvider(value: invalidValue)],
                                          datasourceUrl: url,
                                          cipherConfiguration: CipherConfiguration.chaChaPoly,
                                          logger: mockErrorLogger,
                                          options: [.skipInvalidSecureValues])

        let variable = "secure_toggle"
        let value = try toggleManager.readValue(for: .secure("YXe+Ev76FbdwCeDCVpZNZ1RItWZwKTLXF3/Yi+x62n3JWbvPo6YK"))
        XCTAssertEqual(toggleManager.value(for: variable), value)
        
        XCTAssertTrue(mockErrorLogger.loggedMessages.contains { error in
            if case .insecureValue(let varName, let provider) = error {
                return varName == variable &&
                provider.name == "SingleValue (mock)"
            }
            return false
        })
        
        XCTAssertEqual(mockErrorLogger.loggedMessages.count, 1)
    }

    func test_fallbackToDefaultValue_WhenInMemoryValueProviderHasAPresetInvalidSecureValue_isLogged() throws {
        let url = Bundle.toggles.url(forResource: "TestDatasource", withExtension: "json")!
        let variable = "secure_toggle"
        let invalidValue = Value.secure("my unencrypted string")
        let inMemoryValueProvider = InMemoryValueProvider(datasource: [variable : invalidValue])

        toggleManager = try ToggleManager(mutableValueProvider: inMemoryValueProvider,
                                          datasourceUrl: url,
                                          cipherConfiguration: CipherConfiguration.chaChaPoly,
                                          logger: mockErrorLogger,
                                          options: [.skipInvalidSecureValues])

        let value = try toggleManager.readValue(for: .secure("YXe+Ev76FbdwCeDCVpZNZ1RItWZwKTLXF3/Yi+x62n3JWbvPo6YK"))
        XCTAssertEqual(toggleManager.value(for: variable), value)
        
        XCTAssertTrue(mockErrorLogger.loggedMessages.contains { error in
            if case .insecureValue(let varName, let provider) = error {
                return varName == variable &&
                provider.name == "InMemory"
            }
            return false
        })
        
        XCTAssertEqual(mockErrorLogger.loggedMessages.count, 1)
    }

    func test_fallbackToOtherSecureValue_WhenOtherValueProviderHasAnInvalidSecureValue_isLogged() throws {
        let url = Bundle.toggles.url(forResource: "TestDatasource", withExtension: "json")!
        let invalidValue = Value.secure("my unencrypted string")
        toggleManager = try ToggleManager(valueProviders: [MockSingleValueProvider(value: invalidValue), MockSingleValueProvider(value: .secure("SwYDP6aCtI6L1jkJqE3vdzni/6V/CR9PDvpXG3bbF7t48iWyhjxx"))],
                                          datasourceUrl: url,
                                          cipherConfiguration: CipherConfiguration.chaChaPoly,
                                          logger: mockErrorLogger,
                                          options: [.skipInvalidSecureValues])

        let variable = "secure_toggle"
        let value = try toggleManager.readValue(for: .secure("SwYDP6aCtI6L1jkJqE3vdzni/6V/CR9PDvpXG3bbF7t48iWyhjxx"))
        XCTAssertEqual(toggleManager.value(for: variable), value)
        
        XCTAssertTrue(mockErrorLogger.loggedMessages.contains { error in
            if case .insecureValue(let varName, let provider) = error {
                return varName == variable &&
                provider.name == "SingleValue (mock)"
            }
            return false
        })
        
        XCTAssertEqual(mockErrorLogger.loggedMessages.count, 1)
    }

    func test_fallbackToOtherSecureValue_WhenInMemoryValueProviderHasAnInvalidSecureValue_isLogged() throws {
        let url = Bundle.toggles.url(forResource: "TestDatasource", withExtension: "json")!
        let variable = "secure_toggle"
        let invalidValue = Value.secure("my unencrypted string")
        let inMemoryValueProvider = InMemoryValueProvider(datasource: [variable : invalidValue])

        toggleManager = try ToggleManager(mutableValueProvider: inMemoryValueProvider,
                                          valueProviders: [MockSingleValueProvider(value: .secure("SwYDP6aCtI6L1jkJqE3vdzni/6V/CR9PDvpXG3bbF7t48iWyhjxx"))],
                                          datasourceUrl: url,
                                          cipherConfiguration: CipherConfiguration.chaChaPoly,
                                          logger: mockErrorLogger,
                                          options: [.skipInvalidSecureValues])

        let value = try toggleManager.readValue(for: .secure("SwYDP6aCtI6L1jkJqE3vdzni/6V/CR9PDvpXG3bbF7t48iWyhjxx"))
        XCTAssertEqual(toggleManager.value(for: variable), value)
        
        XCTAssertTrue(mockErrorLogger.loggedMessages.contains { error in
            if case .insecureValue(let varName, let provider) = error {
                return varName == variable &&
                provider.name == "InMemory"
            }
            return false
        })
        
        XCTAssertEqual(mockErrorLogger.loggedMessages.count, 1)
    }

    func test_fallbackToDefaultValue_WhenMultipleOtherValueProvidersHaveInvalidSecureValues_isLogged() throws {
        let url = Bundle.toggles.url(forResource: "TestDatasource", withExtension: "json")!
        let invalidValue1 = Value.secure("my unencrypted string")
        let invalidValue2 = Value.secure("hello world")
        toggleManager = try ToggleManager(valueProviders: [MockSingleValueProvider(value: invalidValue1), MockSingleValueProvider(value: invalidValue2)],
                                          datasourceUrl: url,
                                          cipherConfiguration: CipherConfiguration.chaChaPoly,
                                          logger: mockErrorLogger,
                                          options: [.skipInvalidSecureValues])

        let variable = "secure_toggle"
        let value = try toggleManager.readValue(for: .secure("YXe+Ev76FbdwCeDCVpZNZ1RItWZwKTLXF3/Yi+x62n3JWbvPo6YK"))
        XCTAssertEqual(toggleManager.value(for: variable), value)
        
        XCTAssertTrue(mockErrorLogger.loggedMessages.contains { error in
            if case .insecureValue(let varName, let provider) = error {
                return varName == variable &&
                provider.name == "SingleValue (mock)"
            }
            return false
        })
        
        XCTAssertTrue(mockErrorLogger.loggedMessages.contains { error in
            if case .insecureValue(let varName, let provider) = error {
                return varName == variable &&
                provider.name == "SingleValue (mock)"
            }
            return false
        })
        
        XCTAssertEqual(mockErrorLogger.loggedMessages.count, 2)
    }

    func test_fallbackWhenValueProvidersContainsInvalidSecureValueAndDifferentTypes_AndNoFallBackWhenValueIsNotInDefaultValueProvider_isLogged() throws {
        let url = Bundle.toggles.url(forResource: "TestDatasource", withExtension: "json")!
        let invalidValue1 = Value.string("hello world")
        let invalidValue2 = Value.secure("my unencrypted string")
        toggleManager = try ToggleManager(valueProviders: [MockSingleValueProvider(value: invalidValue1), MockSingleValueProvider(value: invalidValue2)],
                                          datasourceUrl: url,
                                          cipherConfiguration: CipherConfiguration.chaChaPoly,
                                          logger: mockErrorLogger,
                                          options: [.skipInvalidValueTypes, .skipInvalidSecureValues])

        let variableNotInDefaultProvider = "string_toggle_new"
        XCTAssertEqual(toggleManager.value(for: variableNotInDefaultProvider), .string("hello world"))

        let secureVariable = "secure_toggle"
        let value = try toggleManager.readValue(for: .secure("YXe+Ev76FbdwCeDCVpZNZ1RItWZwKTLXF3/Yi+x62n3JWbvPo6YK"))
        XCTAssertEqual(toggleManager.value(for: secureVariable), value)
        
        XCTAssertTrue(mockErrorLogger.loggedMessages.contains { error in
            if case .invalidValueType(let varName, let value, let provider) = error {
                return varName == secureVariable &&
                       value == invalidValue1 &&
                provider.name == "SingleValue (mock)"
            }
            return false
        })
        
        XCTAssertTrue(mockErrorLogger.loggedMessages.contains { error in
            if case .insecureValue(let varName, let provider) = error {
                return varName == secureVariable &&
                provider.name == "SingleValue (mock)"
            }
            return false
        })
        
        XCTAssertEqual(mockErrorLogger.loggedMessages.count, 2)
    }
}
