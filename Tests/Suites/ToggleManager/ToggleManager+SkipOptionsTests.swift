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
    
    func test_fallbackToDefaultValue_WhenOtherValueProviderValueIsADifferentType() throws {
        let url = Bundle.toggles.url(forResource: "TestDatasource", withExtension: "json")!
        toggleManager = try ToggleManager(valueProviders: [MockSingleValueProvider(value: .string("hello world"))], datasourceUrl: url, options: [.skipInvalidValueTypes])
        let variable = "integer_toggle"
        XCTAssertEqual(toggleManager.value(for: variable), Value.int(42))
    }
    
    func test_fallbackToDefaultValue_WhenMultipleOtherValueProviderValuesAreDifferentTypes() throws {
        let url = Bundle.toggles.url(forResource: "TestDatasource", withExtension: "json")!
        toggleManager = try ToggleManager(valueProviders: [MockSingleValueProvider(value: .string("hello world")), MockSingleValueProvider(value: .bool(true))], datasourceUrl: url, options: [.skipInvalidValueTypes])
        let variable = "integer_toggle"
        XCTAssertEqual(toggleManager.value(for: variable), Value.int(42))
    }
    
    func test_fallbackToOtherValidValue_WhenOneValueProviderValueIsADifferentType() throws {
        let url = Bundle.toggles.url(forResource: "TestDatasource", withExtension: "json")!
        toggleManager = try ToggleManager(valueProviders: [MockSingleValueProvider(value: .string("hello world")), MockSingleValueProvider(value: .int(333))], datasourceUrl: url, options: [.skipInvalidValueTypes])
        let variable = "integer_toggle"
        XCTAssertEqual(toggleManager.value(for: variable), Value.int(333))
    }
    
    func test_fallbackToDefaultValue_WhenOtherValueProviderHasAnInvalidSecureValue() throws {
        let url = Bundle.toggles.url(forResource: "TestDatasource", withExtension: "json")!
        toggleManager = try ToggleManager(valueProviders: [MockSingleValueProvider(value: .secure("my unencrypted string"))], datasourceUrl: url, cipherConfiguration: CipherConfiguration.chaChaPoly, options: [.skipInvalidSecureValues])
        
        let variable = "secure_toggle"
        let value = try toggleManager.readValue(for: .secure("YXe+Ev76FbdwCeDCVpZNZ1RItWZwKTLXF3/Yi+x62n3JWbvPo6YK"))
        XCTAssertEqual(toggleManager.value(for: variable), value)
    }
    
    func test_fallbackToDefaultValue_WhenInMemoryValueProviderHasAPresetInvalidSecureValue() throws {
        let url = Bundle.toggles.url(forResource: "TestDatasource", withExtension: "json")!
        let variable = "secure_toggle"
        let inMemoryValueProvider = InMemoryValueProvider(datasource: [variable : .secure("my unencrypted string")])
        
        toggleManager = try ToggleManager(mutableValueProvider: inMemoryValueProvider, datasourceUrl: url, cipherConfiguration: CipherConfiguration.chaChaPoly, options: [.skipInvalidSecureValues])
        
        let value = try toggleManager.readValue(for: .secure("YXe+Ev76FbdwCeDCVpZNZ1RItWZwKTLXF3/Yi+x62n3JWbvPo6YK"))
        XCTAssertEqual(toggleManager.value(for: variable), value)
    }
    
    func test_noFallbackToDefaultValueWhenInMemoryValueProviderHasASecureValueOverride() throws {
        let url = Bundle.toggles.url(forResource: "TestDatasource", withExtension: "json")!
        let variable = "secure_toggle"
        let inMemoryValueProvider = InMemoryValueProvider()
        toggleManager = try ToggleManager(mutableValueProvider: inMemoryValueProvider, datasourceUrl: url, cipherConfiguration: CipherConfiguration.chaChaPoly, options: [.skipInvalidSecureValues])
        
        toggleManager.set(.secure("hello world"), for: variable)
        let value = try toggleManager.readValue(for: .secure("SwYDP6aCtI6L1jkJqE3vdzni/6V/CR9PDvpXG3bbF7t48iWyhjxx"))
        XCTAssertEqual(toggleManager.value(for: variable), value)
    }
    
    func test_fallbackToOtherSecureValue_WhenOtherValueProviderHasAnInvalidSecureValue() throws {
        let url = Bundle.toggles.url(forResource: "TestDatasource", withExtension: "json")!
        toggleManager = try ToggleManager(valueProviders: [MockSingleValueProvider(value: .secure("my unencrypted string")), MockSingleValueProvider(value: .secure("SwYDP6aCtI6L1jkJqE3vdzni/6V/CR9PDvpXG3bbF7t48iWyhjxx"))],
                                          datasourceUrl: url,
                                          cipherConfiguration: CipherConfiguration.chaChaPoly,
                                          options: [.skipInvalidSecureValues])
        let variable = "secure_toggle"
        let value = try toggleManager.readValue(for: .secure("SwYDP6aCtI6L1jkJqE3vdzni/6V/CR9PDvpXG3bbF7t48iWyhjxx"))
        XCTAssertEqual(toggleManager.value(for: variable), value)
    }
    
    func test_fallbackToOtherSecureValue_WhenInMemoryValueProviderHasAnInvalidSecureValue() throws {
        let url = Bundle.toggles.url(forResource: "TestDatasource", withExtension: "json")!
        let variable = "secure_toggle"
        let inMemoryValueProvider = InMemoryValueProvider(datasource: [variable : .secure("my unencrypted string")])
        
        toggleManager = try ToggleManager(mutableValueProvider: inMemoryValueProvider, valueProviders: [MockSingleValueProvider(value: .secure("SwYDP6aCtI6L1jkJqE3vdzni/6V/CR9PDvpXG3bbF7t48iWyhjxx"))], datasourceUrl: url, cipherConfiguration: CipherConfiguration.chaChaPoly, options: [.skipInvalidSecureValues])
        
        let value = try toggleManager.readValue(for: .secure("SwYDP6aCtI6L1jkJqE3vdzni/6V/CR9PDvpXG3bbF7t48iWyhjxx"))
        XCTAssertEqual(toggleManager.value(for: variable), value)
    }
    
    func test_fallbackToDefaultValue_WhenMultipleOtherValueProvidersHaveInvalidSecureValues() throws {
        let url = Bundle.toggles.url(forResource: "TestDatasource", withExtension: "json")!
        toggleManager = try ToggleManager(valueProviders: [MockSingleValueProvider(value: .secure("my unencrypted string")), MockSingleValueProvider(value: .secure("hello world"))], datasourceUrl: url, cipherConfiguration: CipherConfiguration.chaChaPoly, options: [.skipInvalidSecureValues])
        
        let variable = "secure_toggle"
        let value = try toggleManager.readValue(for: .secure("YXe+Ev76FbdwCeDCVpZNZ1RItWZwKTLXF3/Yi+x62n3JWbvPo6YK"))
        XCTAssertEqual(toggleManager.value(for: variable), value)
    }
    
    func test_noFallbackWhenValueProviderContainsValueNotInDefaultValueProvider() throws {
        let url = Bundle.toggles.url(forResource: "TestDatasource", withExtension: "json")!
        toggleManager = try ToggleManager(valueProviders: [MockSingleValueProvider(value: .string("my new addition"))], datasourceUrl: url, options: [.skipInvalidValueTypes])
        let variable = "string_toggle_new"
        XCTAssertEqual(toggleManager.value(for: variable), .string("my new addition"))
    }
    
    func test_fallbackWhenValueProvidersContainsInvalidSecureValueAndDifferentTypes_AndNoFallBackWhenValueIsNotInDefaultValueProvider() throws {
        let url = Bundle.toggles.url(forResource: "TestDatasource", withExtension: "json")!
        toggleManager = try ToggleManager(valueProviders: [MockSingleValueProvider(value: .string("hello world")), MockSingleValueProvider(value: .secure("my unencrypted string"))], datasourceUrl: url, cipherConfiguration: CipherConfiguration.chaChaPoly, options: [.skipInvalidValueTypes, .skipInvalidSecureValues])
        let variableNotInDefaultProvider = "string_toggle_new"
        XCTAssertEqual(toggleManager.value(for: variableNotInDefaultProvider), .string("hello world"))
        
        let secureVariable = "secure_toggle"
        let value = try toggleManager.readValue(for: .secure("YXe+Ev76FbdwCeDCVpZNZ1RItWZwKTLXF3/Yi+x62n3JWbvPo6YK"))
        XCTAssertEqual(toggleManager.value(for: secureVariable), value)
    }
}
