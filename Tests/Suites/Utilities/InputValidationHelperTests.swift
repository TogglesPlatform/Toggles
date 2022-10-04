//  InputValidationHelperTests.swift

import XCTest
@testable import Toggles

final class InputValidationHelperTests: XCTestCase {

    private let factory = ToggleFactory()
    
    func test_inputValidEmpty() throws {
        let toggle = factory.booleanEmptyMetadataToggle(true)
        let inputValidationHelper = InputValidationHelper(toggle: toggle)
        XCTAssertTrue(inputValidationHelper.isInputValid(""))
    }
    
    func test_inputValidBoolTrue() throws {
        let toggle = factory.booleanEmptyMetadataToggle(true)
        let inputValidationHelper = InputValidationHelper(toggle: toggle)
        XCTAssertTrue(inputValidationHelper.isInputValid("true"))
    }
    
    func test_inputValidBoolFalse() throws {
        let toggle = factory.booleanEmptyMetadataToggle(true)
        let inputValidationHelper = InputValidationHelper(toggle: toggle)
        XCTAssertFalse(inputValidationHelper.isInputValid("invalid"))
    }
    
    func test_inputValidIntTrue() throws {
        let toggle = factory.integerEmptyMetadataToggle(42)
        let inputValidationHelper = InputValidationHelper(toggle: toggle)
        XCTAssertTrue(inputValidationHelper.isInputValid("30"))
    }
    
    func test_inputValidIntFalse() throws {
        let toggle = factory.integerEmptyMetadataToggle(42)
        let inputValidationHelper = InputValidationHelper(toggle: toggle)
        XCTAssertFalse(inputValidationHelper.isInputValid("30w"))
    }
    
    func test_inputValidNumberTrue() throws {
        let toggle = factory.numericEmptyMetadataToggle(3.1416)
        let inputValidationHelper = InputValidationHelper(toggle: toggle)
        XCTAssertTrue(inputValidationHelper.isInputValid("30.0"))
    }
    
    func test_inputValidNumberFalse() throws {
        let toggle = factory.numericEmptyMetadataToggle(3.1416)
        let inputValidationHelper = InputValidationHelper(toggle: toggle)
        XCTAssertFalse(inputValidationHelper.isInputValid("30.0w"))
    }
    
    func test_inputValidStringTrue() throws {
        let toggle = factory.stringEmptyMetadataToggle("Hello World")
        let inputValidationHelper = InputValidationHelper(toggle: toggle)
        XCTAssertTrue(inputValidationHelper.isInputValid("Ciao Mondo"))
    }
    
    func test_inputValidSecureTrue() throws {
        let toggle = factory.secureEmptyMetadataToggle("...")
        let inputValidationHelper = InputValidationHelper(toggle: toggle)
        XCTAssertTrue(inputValidationHelper.isInputValid("***"))
    }
    
    func test_overridingValueBoolTrue() throws {
        let toggle = factory.booleanEmptyMetadataToggle(true)
        let inputValidationHelper = InputValidationHelper(toggle: toggle)
        XCTAssertEqual(inputValidationHelper.overridingValue(for: "true"), .bool(true))
        XCTAssertEqual(inputValidationHelper.overridingValue(for: "false"), .bool(false))
        XCTAssertEqual(inputValidationHelper.overridingValue(for: "invalid"), .bool(false))
    }
    
    func test_overridingValueInt() throws {
        let toggle = factory.integerEmptyMetadataToggle(42)
        let inputValidationHelper = InputValidationHelper(toggle: toggle)
        XCTAssertEqual(inputValidationHelper.overridingValue(for: "108"), .int(108))
        XCTAssertEqual(inputValidationHelper.overridingValue(for: "invalid"), .int(0))
    }
    
    func test_overridingValueNumber() throws {
        let toggle = factory.numericEmptyMetadataToggle(3.1416)
        let inputValidationHelper = InputValidationHelper(toggle: toggle)
        XCTAssertEqual(inputValidationHelper.overridingValue(for: "108.12"), .number(108.12))
        XCTAssertEqual(inputValidationHelper.overridingValue(for: "invalid"), .number(0.0))
    }
    
    func test_overridingValueString() throws {
        let toggle = factory.stringEmptyMetadataToggle("Hello World")
        let inputValidationHelper = InputValidationHelper(toggle: toggle)
        XCTAssertEqual(inputValidationHelper.overridingValue(for: "Ciao Mondo"), .string("Ciao Mondo"))
    }
    
    func test_overridingValueSecure() throws {
        let toggle = factory.secureEmptyMetadataToggle("...")
        let inputValidationHelper = InputValidationHelper(toggle: toggle)
        XCTAssertEqual(inputValidationHelper.overridingValue(for: "***"), .secure("***"))
    }
    
#if os(iOS)
    func test_keyboardTypeBool() throws {
        let toggle = factory.booleanEmptyMetadataToggle(true)
        let inputValidationHelper = InputValidationHelper(toggle: toggle)
        XCTAssertEqual(inputValidationHelper.keyboardType, .default)
    }
    
    func test_keyboardTypeInt() throws {
        let toggle = factory.integerEmptyMetadataToggle(42)
        let inputValidationHelper = InputValidationHelper(toggle: toggle)
        XCTAssertEqual(inputValidationHelper.keyboardType, .numberPad)
    }
    
    func test_keyboardTypeNumber() throws {
        let toggle = factory.numericEmptyMetadataToggle(3.1416)
        let inputValidationHelper = InputValidationHelper(toggle: toggle)
        XCTAssertEqual(inputValidationHelper.keyboardType, .decimalPad)
    }
    
    func test_keyboardTypeString() throws {
        let toggle = factory.stringEmptyMetadataToggle("Hello World")
        let inputValidationHelper = InputValidationHelper(toggle: toggle)
        XCTAssertEqual(inputValidationHelper.keyboardType, .default)
    }
    
    func test_keyboardTypeSecure() throws {
        let toggle = factory.secureEmptyMetadataToggle("...")
        let inputValidationHelper = InputValidationHelper(toggle: toggle)
        XCTAssertEqual(inputValidationHelper.keyboardType, .default)
    }
#endif
    
    func test_isBooleanToggleBool() throws {
        let toggle = factory.booleanEmptyMetadataToggle(true)
        let inputValidationHelper = InputValidationHelper(toggle: toggle)
        XCTAssertTrue(inputValidationHelper.isBooleanToggle)
    }
    
    func test_isBooleanToggleInt() throws {
        let toggle = factory.integerEmptyMetadataToggle(42)
        let inputValidationHelper = InputValidationHelper(toggle: toggle)
        XCTAssertFalse(inputValidationHelper.isBooleanToggle)
    }
    
    func test_isBooleanToggleNumber() throws {
        let toggle = factory.numericEmptyMetadataToggle(3.1416)
        let inputValidationHelper = InputValidationHelper(toggle: toggle)
        XCTAssertFalse(inputValidationHelper.isBooleanToggle)
    }
    
    func test_isBooleanToggleString() throws {
        let toggle = factory.stringEmptyMetadataToggle("Hello World")
        let inputValidationHelper = InputValidationHelper(toggle: toggle)
        XCTAssertFalse(inputValidationHelper.isBooleanToggle)
    }
    
    func test_isBooleanToggleSecure() throws {
        let toggle = factory.secureEmptyMetadataToggle("...")
        let inputValidationHelper = InputValidationHelper(toggle: toggle)
        XCTAssertFalse(inputValidationHelper.isBooleanToggle)
    }
    
    func test_toggleNeedsValidationBool() throws {
        let toggle = factory.booleanEmptyMetadataToggle(true)
        let inputValidationHelper = InputValidationHelper(toggle: toggle)
        XCTAssertFalse(inputValidationHelper.toggleNeedsValidation)
    }
    
    func test_toggleNeedsValidationInt() throws {
        let toggle = factory.integerEmptyMetadataToggle(42)
        let inputValidationHelper = InputValidationHelper(toggle: toggle)
        XCTAssertTrue(inputValidationHelper.toggleNeedsValidation)
    }
    
    func test_toggleNeedsValidationNumber() throws {
        let toggle = factory.numericEmptyMetadataToggle(3.1416)
        let inputValidationHelper = InputValidationHelper(toggle: toggle)
        XCTAssertTrue(inputValidationHelper.toggleNeedsValidation)
    }
    
    func test_toggleNeedsValidationString() throws {
        let toggle = factory.stringEmptyMetadataToggle("Hello World")
        let inputValidationHelper = InputValidationHelper(toggle: toggle)
        XCTAssertFalse(inputValidationHelper.toggleNeedsValidation)
    }
    
    func test_toggleNeedsValidationSecure() throws {
        let toggle = factory.secureEmptyMetadataToggle("...")
        let inputValidationHelper = InputValidationHelper(toggle: toggle)
        XCTAssertFalse(inputValidationHelper.toggleNeedsValidation)
    }
}
