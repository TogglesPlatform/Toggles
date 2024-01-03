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
    
    private class myErrorLogger: ErrorLogger {
        public var loggedMessages: [String] = []
        
        func logError(_ error: ToggleManager.ProviderValueError) {
            switch error {
            case .invalidValueType(let message):
                loggedMessages.append(message)
            case .insecureValue(let message):
                loggedMessages.append(message)
            }
        }
    }
    
    func test_fallbackToDefaultValue_WhenOtherValueProviderValueIsADifferentType_isLogged() throws {
        let url = Bundle.toggles.url(forResource: "TestDatasource", withExtension: "json")!
        let invalidValue = Value.string("hello world")
        toggleManager = try ToggleManager(valueProviders: [MockSingleValueProvider(value: invalidValue)], datasourceUrl: url, errorLogger: mockErrorLogger, options: [.skipInvalidValueTypes])
        let variable = "integer_toggle"
        XCTAssertEqual(toggleManager.value(for: variable), Value.int(42))
        XCTAssertEqual(mockErrorLogger.loggedMessages[0], "\(variable) was found with an invalid type (\(invalidValue.toggleTypeDescription)) in Provider: SingleValue (mock)")
        XCTAssertEqual(mockErrorLogger.loggedMessages.count, 1)
    }
    
    func test_fallbackToDefaultValue_WhenMultipleOtherValueProviderValuesAreDifferentTypes_isLogged() throws {
        let url = Bundle.toggles.url(forResource: "TestDatasource", withExtension: "json")!
        let invalidValue1 = Value.string("hello world")
        let invalidValue2 = Value.bool(true)
        toggleManager = try ToggleManager(valueProviders: [MockSingleValueProvider(value: invalidValue1), MockSingleValueProvider(value: invalidValue2)], datasourceUrl: url, errorLogger: mockErrorLogger, options: [.skipInvalidValueTypes])
        let variable = "integer_toggle"
        XCTAssertEqual(toggleManager.value(for: variable), Value.int(42))
        XCTAssertEqual(mockErrorLogger.loggedMessages[0], "\(variable) was found with an invalid type (\(invalidValue1.toggleTypeDescription)) in Provider: SingleValue (mock)")
        XCTAssertEqual(mockErrorLogger.loggedMessages[1], "\(variable) was found with an invalid type (\(invalidValue2.toggleTypeDescription)) in Provider: SingleValue (mock)")
        XCTAssertEqual(mockErrorLogger.loggedMessages.count, 2)
    }
    
    func test_fallbackToOtherValidValue_WhenOneValueProviderValueIsADifferentType_isLogged() throws {
        let url = Bundle.toggles.url(forResource: "TestDatasource", withExtension: "json")!
        let invalidValue = Value.string("hello world")
        toggleManager = try ToggleManager(valueProviders: [MockSingleValueProvider(value: invalidValue), MockSingleValueProvider(value: .int(333))], datasourceUrl: url, errorLogger: mockErrorLogger, options: [.skipInvalidValueTypes])
        let variable = "integer_toggle"
        XCTAssertEqual(toggleManager.value(for: variable), Value.int(333))
        XCTAssertEqual(mockErrorLogger.loggedMessages[0], "\(variable) was found with an invalid type (\(invalidValue.toggleTypeDescription)) in Provider: SingleValue (mock)")
        XCTAssertEqual(mockErrorLogger.loggedMessages.count, 1)
    }
    
    func test_fallbackToDefaultValue_WhenOtherValueProviderHasAnInvalidSecureValue_isLogged() throws {
        let url = Bundle.toggles.url(forResource: "TestDatasource", withExtension: "json")!
        toggleManager = try ToggleManager(valueProviders: [MockSingleValueProvider(value: .secure("my unencrypted string"))],
                                          datasourceUrl: url,
                                          cipherConfiguration: CipherConfiguration.chaChaPoly,
                                          errorLogger: mockErrorLogger,
                                          options: [.skipInvalidSecureValues])
        
        let variable = "secure_toggle"
        let value = try toggleManager.readValue(for: .secure("YXe+Ev76FbdwCeDCVpZNZ1RItWZwKTLXF3/Yi+x62n3JWbvPo6YK"))
        XCTAssertEqual(toggleManager.value(for: variable), value)
        XCTAssertEqual(mockErrorLogger.loggedMessages[0], "\(variable) was found with an invalid secure value in Provider: SingleValue (mock)")
        XCTAssertEqual(mockErrorLogger.loggedMessages.count, 1)
    }
    
    func test_fallbackToDefaultValue_WhenInMemoryValueProviderHasAPresetInvalidSecureValue_isLogged() throws {
        let url = Bundle.toggles.url(forResource: "TestDatasource", withExtension: "json")!
        let variable = "secure_toggle"
        let inMemoryValueProvider = InMemoryValueProvider(datasource: [variable : .secure("my unencrypted string")])
        
        toggleManager = try ToggleManager(mutableValueProvider: inMemoryValueProvider,
                                          datasourceUrl: url,
                                          cipherConfiguration: CipherConfiguration.chaChaPoly,
                                          errorLogger: mockErrorLogger,
                                          options: [.skipInvalidSecureValues])
        
        let value = try toggleManager.readValue(for: .secure("YXe+Ev76FbdwCeDCVpZNZ1RItWZwKTLXF3/Yi+x62n3JWbvPo6YK"))
        XCTAssertEqual(toggleManager.value(for: variable), value)
        XCTAssertEqual(mockErrorLogger.loggedMessages[0], "\(variable) was found with an invalid secure value in Provider: InMemory")
        XCTAssertEqual(mockErrorLogger.loggedMessages.count, 1)
    }
    
    func test_fallbackToOtherSecureValue_WhenOtherValueProviderHasAnInvalidSecureValue_isLogged() throws {
        let url = Bundle.toggles.url(forResource: "TestDatasource", withExtension: "json")!
        toggleManager = try ToggleManager(valueProviders: [MockSingleValueProvider(value: .secure("my unencrypted string")), MockSingleValueProvider(value: .secure("SwYDP6aCtI6L1jkJqE3vdzni/6V/CR9PDvpXG3bbF7t48iWyhjxx"))],
                                          datasourceUrl: url,
                                          cipherConfiguration: CipherConfiguration.chaChaPoly,
                                          errorLogger: mockErrorLogger,
                                          options: [.skipInvalidSecureValues])
        
        let variable = "secure_toggle"
        let value = try toggleManager.readValue(for: .secure("SwYDP6aCtI6L1jkJqE3vdzni/6V/CR9PDvpXG3bbF7t48iWyhjxx"))
        XCTAssertEqual(toggleManager.value(for: variable), value)
        XCTAssertEqual(mockErrorLogger.loggedMessages[0], "\(variable) was found with an invalid secure value in Provider: SingleValue (mock)")
        XCTAssertEqual(mockErrorLogger.loggedMessages.count, 1)
    }
    
    func test_fallbackToOtherSecureValue_WhenInMemoryValueProviderHasAnInvalidSecureValue_isLogged() throws {
        let url = Bundle.toggles.url(forResource: "TestDatasource", withExtension: "json")!
        let variable = "secure_toggle"
        let inMemoryValueProvider = InMemoryValueProvider(datasource: [variable : .secure("my unencrypted string")])
        
        toggleManager = try ToggleManager(mutableValueProvider: inMemoryValueProvider,
                                          valueProviders: [MockSingleValueProvider(value: .secure("SwYDP6aCtI6L1jkJqE3vdzni/6V/CR9PDvpXG3bbF7t48iWyhjxx"))],
                                          datasourceUrl: url,
                                          cipherConfiguration: CipherConfiguration.chaChaPoly,
                                          errorLogger: mockErrorLogger,
                                          options: [.skipInvalidSecureValues])
        
        let value = try toggleManager.readValue(for: .secure("SwYDP6aCtI6L1jkJqE3vdzni/6V/CR9PDvpXG3bbF7t48iWyhjxx"))
        XCTAssertEqual(toggleManager.value(for: variable), value)
        XCTAssertEqual(mockErrorLogger.loggedMessages[0], "\(variable) was found with an invalid secure value in Provider: InMemory")
        XCTAssertEqual(mockErrorLogger.loggedMessages.count, 1)
    }
    
    func test_fallbackToDefaultValue_WhenMultipleOtherValueProvidersHaveInvalidSecureValues_isLogged() throws {
        let url = Bundle.toggles.url(forResource: "TestDatasource", withExtension: "json")!
        toggleManager = try ToggleManager(valueProviders: [MockSingleValueProvider(value: .secure("my unencrypted string")), MockSingleValueProvider(value: .secure("hello world"))],
                                          datasourceUrl: url,
                                          cipherConfiguration: CipherConfiguration.chaChaPoly,
                                          errorLogger: mockErrorLogger,
                                          options: [.skipInvalidSecureValues])
        
        let variable = "secure_toggle"
        let value = try toggleManager.readValue(for: .secure("YXe+Ev76FbdwCeDCVpZNZ1RItWZwKTLXF3/Yi+x62n3JWbvPo6YK"))
        XCTAssertEqual(toggleManager.value(for: variable), value)
        XCTAssertEqual(mockErrorLogger.loggedMessages[0], "\(variable) was found with an invalid secure value in Provider: SingleValue (mock)")
        XCTAssertEqual(mockErrorLogger.loggedMessages[1], "\(variable) was found with an invalid secure value in Provider: SingleValue (mock)")
        XCTAssertEqual(mockErrorLogger.loggedMessages.count, 2)
    }
    
    func test_fallbackWhenValueProvidersContainsInvalidSecureValueAndDifferentTypes_AndNoFallBackWhenValueIsNotInDefaultValueProvider_isLogged() throws {
        let url = Bundle.toggles.url(forResource: "TestDatasource", withExtension: "json")!
        let invalidValue1 = Value.string("hello world")
        toggleManager = try ToggleManager(valueProviders: [MockSingleValueProvider(value: invalidValue1), MockSingleValueProvider(value: .secure("my unencrypted string"))],
                                          datasourceUrl: url,
                                          cipherConfiguration: CipherConfiguration.chaChaPoly,
                                          errorLogger: mockErrorLogger,
                                          options: [.skipInvalidValueTypes, .skipInvalidSecureValues])
        
        let variableNotInDefaultProvider = "string_toggle_new"
        XCTAssertEqual(toggleManager.value(for: variableNotInDefaultProvider), .string("hello world"))
        
        let secureVariable = "secure_toggle"
        let value = try toggleManager.readValue(for: .secure("YXe+Ev76FbdwCeDCVpZNZ1RItWZwKTLXF3/Yi+x62n3JWbvPo6YK"))
        XCTAssertEqual(toggleManager.value(for: secureVariable), value)
        XCTAssertEqual(mockErrorLogger.loggedMessages[0], "\(secureVariable) was found with an invalid type (\(invalidValue1.toggleTypeDescription)) in Provider: SingleValue (mock)")
        XCTAssertEqual(mockErrorLogger.loggedMessages[1], "\(secureVariable) was found with an invalid secure value in Provider: SingleValue (mock)")
        XCTAssertEqual(mockErrorLogger.loggedMessages.count, 2)
    }
}
