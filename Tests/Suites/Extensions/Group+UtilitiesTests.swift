//  Group+UtilitiesTests.swift

import XCTest
@testable import Toggles

final class Group_UtilitiesTests: XCTestCase {
    
    func test_accessibilityLabelNoToggles() throws {
        let group = Group(title: "test group", toggles: [])
        let accessibilityLabel = "Group test group has no toggles"
        XCTAssertEqual(group.accessibilityLabel, accessibilityLabel)
    }
    
    func test_accessibilityLabel1Toggle() throws {
        let toggles = [
            Toggle(variable: "", value: .bool(true), metadata: Metadata(description: "", group: ""))
        ]
        let group = Group(title: "test group", toggles: toggles)
        let accessibilityLabel = "Group test group has 1 toggle"
        XCTAssertEqual(group.accessibilityLabel, accessibilityLabel)
    }
    
    func test_accessibilityLabelMultipleToggles() throws {
        let toggles = [
            Toggle(variable: "", value: .bool(true), metadata: Metadata(description: "", group: "")),
            Toggle(variable: "", value: .bool(true), metadata: Metadata(description: "", group: ""))
        ]
        let group = Group(title: "test group", toggles: toggles)
        let accessibilityLabel = "Group test group has 2 toggles"
        XCTAssertEqual(group.accessibilityLabel, accessibilityLabel)
    }
}
