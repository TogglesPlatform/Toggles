//  Toggle+UtilitiesTests.swift

import XCTest
@testable import Toggles

final class Toggle_UtilitiesTests: XCTestCase {
    
    func test_accessibilityLabel() {
        let toggle = ToggleFactory().integerToggle(42)
        let accessibilityLabel = toggle.metadata.description + "has value" + toggle.value.description
        XCTAssertEqual(toggle.accessibilityLabel, accessibilityLabel)
    }
}
