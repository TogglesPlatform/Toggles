//  Toggle+UtilitiesTests.swift

import XCTest
@testable import Toggles

final class Toggle_UtilitiesTests: XCTestCase {
    
    func test_accessibilityLabel() throws {
        let toggle = ToggleFactory().integerToggle(42)
        let accessibilityLabel = toggle.metadata.description + "has value" + toggle.value.description
        XCTAssertEqual(toggle.accessibilityLabel, accessibilityLabel)
    }
    
    func test_byUpdatingValue() throws {
        let toggle = ToggleFactory().integerToggle(42)
        XCTAssertEqual(toggle.value, .int(42))
        let updatedToggle = toggle.byUpdatingValue(.string("Hello World"))
        XCTAssertEqual(updatedToggle.value, .string("Hello World"))
    }
}
