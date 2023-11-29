//  ToggleManager+OptionsTests.swift

@testable import Toggles
import XCTest

final class ToggleManager_OptionsTests: XCTestCase {
    private var toggleManager: ToggleManager!
    
    override func tearDown() {
        toggleManager.removeOverrides()
        toggleManager = nil
        super.tearDown()
    }
    
    //check fallback to default value when other value provider is different type
    func test_fallbackToDefaultValueWhenOtherValueProviderIsADifferentType() throws {
        let url = Bundle.toggles.url(forResource: "TestDatasource", withExtension: "json")!
        toggleManager = try ToggleManager(valueProviders: [MockSingleValueProvider(value: .string("hello world"))], datasourceUrl: url, options: [.skipInvalidValueTypes])
        let variable = "integer_toggle"
        XCTAssertEqual(toggleManager.value(for: variable), Value.int(42))
    }
    
    //check fallback to default when multiple value providers is different type
    func test_fallbackToDefaultValueWhenMultipleOtherValueProviderAreDifferentTypes() throws {
        let url = Bundle.toggles.url(forResource: "TestDatasource", withExtension: "json")!
        toggleManager = try ToggleManager(valueProviders: [MockSingleValueProvider(value: .string("hello world")), MockSingleValueProvider(value: .bool(true))], datasourceUrl: url, options: [.skipInvalidValueTypes])
        let variable = "integer_toggle"
        XCTAssertEqual(toggleManager.value(for: variable), Value.int(42))
    }
    
    //check fallback to other valid value when only one value provider is different type
    func test_fallbackToOtherValidValueWhenOneValueProviderIsADifferentType() throws {
        let url = Bundle.toggles.url(forResource: "TestDatasource", withExtension: "json")!
        toggleManager = try ToggleManager(valueProviders: [MockSingleValueProvider(value: .string("hello world")), MockSingleValueProvider(value: .int(333))], datasourceUrl: url, options: [.skipInvalidValueTypes])
        let variable = "integer_toggle"
        XCTAssertEqual(toggleManager.value(for: variable), Value.int(333))
    }
    
    //check fallback to default value type when other one value provider has invalid secure value
    func test_fallbackToDefaultValueWhenOtherValueProviderHasAnInvalidSecureValue() throws {
        let url = Bundle.toggles.url(forResource: "TestDatasource", withExtension: "json")!
        toggleManager = try ToggleManager(valueProviders: [MockSingleValueProvider(value: .secure("my unencrypted string"))], datasourceUrl: url, cipherConfiguration: CipherConfiguration.chaChaPoly, options: [.skipInvalidSecureValues])
        let variable = "secure_toggle"
        let value = try toggleManager.readValue(for: .secure("YXe+Ev76FbdwCeDCVpZNZ1RItWZwKTLXF3/Yi+x62n3JWbvPo6YK"))
        XCTAssertEqual(toggleManager.value(for: variable), value)
    }
    
    //check fallback to default value type when other in memory value provider has invalid secure value==========
    func test_fallbackToDefaultValueWhenOtherInMemoryValueProviderHasAnInvalidSecureValue() throws {
        let url = Bundle.toggles.url(forResource: "TestDatasource", withExtension: "json")!
        let variable = "secure_toggle"
        let inMemoryValueProvider = InMemoryValueProvider(datasource: [variable : .secure("my unencrypted string")])
        toggleManager = try ToggleManager(mutableValueProvider: inMemoryValueProvider, datasourceUrl: url, cipherConfiguration: CipherConfiguration.chaChaPoly, options: [.skipInvalidSecureValues])
        
        let value = try toggleManager.readValue(for: .secure("YXe+Ev76FbdwCeDCVpZNZ1RItWZwKTLXF3/Yi+x62n3JWbvPo6YK"))
        XCTAssertEqual(toggleManager.value(for: variable), value)
    }
    
    //check fallback to default value type when other in memory value provider has invalid secure value override==========
    func test_fallbackToDefaultValueWhenOtherInMemoryValueProviderHasAnInvalidSecureValueOverride() throws {
        let url = Bundle.toggles.url(forResource: "TestDatasource", withExtension: "json")!
        let variable = "secure_toggle"
        let inMemoryValueProvider = InMemoryValueProvider()
        toggleManager = try ToggleManager(mutableValueProvider: inMemoryValueProvider, datasourceUrl: url, cipherConfiguration: CipherConfiguration.chaChaPoly, options: [.skipInvalidSecureValues])
        
        toggleManager.set(.secure("my unencrypted string"), for: variable)
        let value = try toggleManager.readValue(for: .secure("YXe+Ev76FbdwCeDCVpZNZ1RItWZwKTLXF3/Yi+x62n3JWbvPo6YK"))
        XCTAssertEqual(toggleManager.value(for: variable), value)
    }
    
    //check fallback to other valid value when other value provider has invalid secure value
    func test_fallbackToOtherSecureValueWhenOtherValueProviderHasAnInvalidSecureValue() throws {
        let url = Bundle.toggles.url(forResource: "TestDatasource", withExtension: "json")!
        toggleManager = try ToggleManager(valueProviders: [MockSingleValueProvider(value: .secure("my unencrypted string")), MockSingleValueProvider(value: .secure("SwYDP6aCtI6L1jkJqE3vdzni/6V/CR9PDvpXG3bbF7t48iWyhjxx"))], datasourceUrl: url, cipherConfiguration: CipherConfiguration.chaChaPoly, options: [.skipInvalidSecureValues])
        let variable = "secure_toggle"
        let value = try toggleManager.readValue(for: .secure("SwYDP6aCtI6L1jkJqE3vdzni/6V/CR9PDvpXG3bbF7t48iWyhjxx"))
        XCTAssertEqual(toggleManager.value(for: variable), value)
    }
    
    //check fallback to other valid value when other value provider has invalid secure value with in memory provider======
    func test_fallbackToOtherSecureValueWhenOtherValueProviderHasAnInvalidSecureValueWithInMemoryProvider() throws {
        let url = Bundle.toggles.url(forResource: "TestDatasource", withExtension: "json")!
        let variable = "secure_toggle"
        let inMemoryValueProvider = InMemoryValueProvider(datasource: [variable : .secure("my unencrypted string")])
        
        toggleManager = try ToggleManager(valueProviders: [MockSingleValueProvider(value: .secure("SwYDP6aCtI6L1jkJqE3vdzni/6V/CR9PDvpXG3bbF7t48iWyhjxx"))], datasourceUrl: url, cipherConfiguration: CipherConfiguration.chaChaPoly, options: [.skipInvalidSecureValues])
        
        let value = try toggleManager.readValue(for: .secure("SwYDP6aCtI6L1jkJqE3vdzni/6V/CR9PDvpXG3bbF7t48iWyhjxx"))
        XCTAssertEqual(toggleManager.value(for: variable), value)
    }
    
    //check fallback to default when multiple value providers has invalid secure value
    func test_fallbackToDefaultValueWhenMultipleOtherValueProvidersHaveInvalidSecureValues() throws {
        let url = Bundle.toggles.url(forResource: "TestDatasource", withExtension: "json")!
        toggleManager = try ToggleManager(valueProviders: [MockSingleValueProvider(value: .secure("my unencrypted string")), MockSingleValueProvider(value: .secure("hello world"))], datasourceUrl: url, cipherConfiguration: CipherConfiguration.chaChaPoly, options: [.skipInvalidSecureValues])
        let variable = "secure_toggle"
        let value = try toggleManager.readValue(for: .secure("YXe+Ev76FbdwCeDCVpZNZ1RItWZwKTLXF3/Yi+x62n3JWbvPo6YK"))
        XCTAssertEqual(toggleManager.value(for: variable), value)
    }
    
    //check no fallback when there is no default value
    func test_noFallbackWhenValueProviderContainsValueNotInDefaultValueProvider() throws {
        let url = Bundle.toggles.url(forResource: "TestDatasource", withExtension: "json")!
        toggleManager = try ToggleManager(valueProviders: [MockSingleValueProvider(value: .string("hello world"))], datasourceUrl: url, options: [.skipInvalidValueTypes])
        let variable = "string_toggle_new"
        XCTAssertEqual(toggleManager.value(for: variable), .string("hello world"))
    }
    
    
    //check fallback with invalid secure, fallback with invalid type, no fallback with no default value
    func test_fallbackWhenValueProvidersContainsInvalidSecureValueAndDifferentTypesAndNoFallBackWhenValueIsNotInDefaultValueProvider() throws {
        let url = Bundle.toggles.url(forResource: "TestDatasource", withExtension: "json")!
        toggleManager = try ToggleManager(valueProviders: [MockSingleValueProvider(value: .string("hello world")), MockSingleValueProvider(value: .secure("my unencrypted string"))], datasourceUrl: url, cipherConfiguration: CipherConfiguration.chaChaPoly, options: [.skipInvalidValueTypes, .skipInvalidSecureValues])
        let variableNotInDefaultProvider = "string_toggle_new"
        let secureVariable = "secure_toggle"
        XCTAssertEqual(toggleManager.value(for: variableNotInDefaultProvider), .string("hello world"))
        
        let value = try toggleManager.readValue(for: .secure("YXe+Ev76FbdwCeDCVpZNZ1RItWZwKTLXF3/Yi+x62n3JWbvPo6YK"))
        XCTAssertEqual(toggleManager.value(for: secureVariable), value)
    }
    
    // MARK: - DefaultValueProvider
    
    func test_value() throws {
        let url = Bundle.toggles.url(forResource: "TestDatasource", withExtension: "json")!
        toggleManager = try ToggleManager(valueProviders: [MockSingleValueProvider(value: .string("hello world"))], datasourceUrl: url)
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
